import os, re, base64, gzip, shutil, requests
import numpy as np
import pandas as pd
import pymysql
from io import BytesIO
from pathlib import Path
from wordcloud import WordCloud
from kiwipiepy import Kiwi
from gensim.models.fasttext import load_facebook_vectors
from models import WordcloudAndRatings

# ----------------------------------
# DB 연결 함수
# ----------------------------------
def db_connect(query, columns):
    conn = pymysql.connect(
        host='project-db-cgi.smhrd.com', port=3307,
        user='CGI_25IS_LI_P2_3', password='smhrd3',
        db='CGI_25IS_LI_P2_3', charset='utf8mb4'
    )
    try:
        with conn.cursor() as cur:
            cur.execute(query)
            rows = cur.fetchall()
            return pd.DataFrame(rows, columns=columns)
    finally:
        conn.close()
# ----------------------------------
# 공용: 워드클라우드(Base64)
# ----------------------------------
def _pick_korean_font():
    for p in [r"C:\Windows\Fonts\malgun.ttf",
              r"/System/Library/Fonts/AppleSDGothicNeo.ttc",
              r"/usr/share/fonts/truetype/nanum/NanumGothic.ttf"]:
        if Path(p).exists(): return p
    return None

def text_to_base64_wordcloud(text: str) -> str:
    if not text or not text.strip():
        # 빈 문자열이면 빈 문자열 반환하거나 기본 이미지 반환
        return ""  # 또는 None, 필요하면 기본 워드클라우드 이미지 base64 인코딩 반환
    wc = WordCloud(width=400, height=400, background_color="white",
                   font_path=_pick_korean_font())
    wc.generate(text)
    buf = BytesIO()
    wc.to_image().save(buf, format="PNG")
    return base64.b64encode(buf.getvalue()).decode()

# ----------------------------------
# fastText 모델 준비
# ----------------------------------
def ensure_fasttext_bin(bin_path: Path, url: str) -> Path:
    bin_path.parent.mkdir(parents=True, exist_ok=True)
    if bin_path.exists():
        print(f"[OK] fastText 모델 사용: {bin_path}")
        return bin_path
    gz_path = bin_path.with_suffix('.bin.gz') if bin_path.suffix != '.gz' else bin_path
    print("[INFO] fastText 모델 다운로드 시작...")
    with requests.get(url, stream=True, timeout=120) as r:
        r.raise_for_status()
        with open(gz_path, 'wb') as f:
            shutil.copyfileobj(r.raw, f)
    print("[INFO] 다운로드 완료. 압축 해제 중...")
    if gz_path.suffix == '.gz':
        with gzip.open(gz_path, 'rb') as src, open(bin_path, 'wb') as dst:
            shutil.copyfileobj(src, dst)
        try: os.remove(gz_path)
        except: pass
    print(f"[OK] 준비 완료: {bin_path}")
    return bin_path

# 전역 fastText 모델 로드
if 'kv' not in globals():
    FT_BIN  = Path(r"C:\emb\cc.ko.300.bin")
    BIN_URL = "https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.ko.300.bin.gz"
    FT_BIN = ensure_fasttext_bin(FT_BIN, BIN_URL)
    kv = load_facebook_vectors(str(FT_BIN))

# 벡터 정규화
def _unit(v):
    n = np.linalg.norm(v)
    return v/n if n else v

# ----------------------------------
# 감성 분석 축(SENT_AXIS) 생성
# ----------------------------------
def build_axis(kv, pairs=[('좋다','나쁘다'), ('만족','불만')]):
    axes=[]
    for a,b in pairs:
        try:
            axes.append(_unit(kv.get_vector(a)-kv.get_vector(b)))
        except:
            pass
    if not axes:
        raise RuntimeError("감성 앵커 벡터를 찾지 못함")
    return _unit(np.mean(axes, axis=0))

# 전역 감성 축 생성 (음식점 특화 확장)
if 'SENT_AXIS' not in globals():
    SENT_AXIS = build_axis(kv, pairs=[
        # 전반/만족도
        ('좋다','나쁘다'),
        ('만족스럽다','실망스럽다'),
        ('훌륭하다','형편없다'),
        ('추천하다','비추천'),
        ('괜찮다','별로다'),

        # 맛/간/풍미
        ('맛있다','맛없다'),
        ('담백하다','느끼하다'),
        ('고소하다','텁텁하다'),
        ('진하다','묽다'),
        ('풍부하다','밋밋하다'),
        ('향긋하다','비리다'),
        ('달콤하다','쓰다'),
        ('짭짤하다','싱겁다'),
        ('간이딱맞다','간이안맞다'),
        ('안짜다','짜다'),             # “안짜다”가 긍정, “짜다”가 부정으로 기울도록

        # 식감/조리상태
        ('부드럽다','질기다'),
        ('바삭하다','눅눅하다'),
        ('촉촉하다','마르다'),
        ('쫄깃하다','퍽퍽하다'),
        ('신선하다','상하다'),
        ('잘익다','덜익다'),
        ('살살녹다','질기다'),

        # 양/가격/가성비
        ('푸짐하다','부족하다'),
        ('넉넉하다','적다'),
        ('가성비좋다','비싸다'),
        ('합리적이다','바가지'),

        # 서비스/응대/속도
        ('친절하다','불친절하다'),
        ('세심하다','대충하다'),
        ('성의있다','불성의하다'),
        ('빠르다','느리다'),
        ('쾌속하다','지연되다'),

        # 위생/청결
        ('깔끔하다','지저분하다'),
        ('청결하다','더럽다'),
        ('위생적이다','비위생적이다'),
        ('정갈하다','허술하다'),

        # 분위기/쾌적함/소음
        ('아늑하다','시끄럽다'),
        ('쾌적하다','답답하다'),
        ('편안하다','불편하다'),

        # 대기/혼잡/접근성/주차
        ('여유롭다','붐비다'),
        ('한산하다','혼잡하다'),
        ('접근성좋다','접근성나쁘다'),
        ('주차편하다','주차불편하다'),
    ])

# ----------------------------------
# 형태소/부정·강조 사전
# ----------------------------------
kiwi = Kiwi()

# 부정 부사/접두어
NEG_CUES = {'전혀','아니','아닌',}
NEG_ADV  = {'별로','그닥','그다지','영','별루'}

# 긍정(강조) 부사/표현
POS_ADV  = {'정말','아주','매우','진짜','완전','최고','최상','대박','너무','넘','굉장히','무척','엄청','킹왕짱'}

# 의미 없는 동사/형용사 (제외)
STOP_LEMMAS = {
    '가다','오다','오르다','내리다','나가다','들어가다','들다','나다','나오다','주다','받다','보다','듣다',
    '시키다','먹다','마시다','있다','없다','하다','되다','사다','팔다','살다','일어나다','타다','걷다','달리다',
    '같다','다르다'
}

# ✅ 명사 화이트리스트: 메뉴명 배제, 품질/환경/서비스 관련 명사만 허용
NOUN_WHITELIST = {
    # 위생/청결/환경
    '위생','위생적','청결','청결도','깔끔함','쾌적','쾌적함','청결상태','위생상태',
    # 분위기/공간/소음
    '분위기','공간','소음','소란','아늑함','편안함','조명','인테리어','통풍',
    # 서비스/응대/속도
    '서비스','응대','속도','대응','배려','세심함','친절','불친절','성의',
    # 가격/가성비/양
    '가성비','가격','비용','가격대','양','분량','푸짐함','소량','할인',
    # 대기/혼잡/접근성/주차
    '대기','웨이팅','혼잡','붐빔','접근성','주차','주차장','좌석','테이블',
    # 신선도/재료/퀄리티
    '신선도','신선함','재료','원재료','퀄리티','품질',
    # 문제/위생 이슈
    '이물질','머리카락','위생문제','불량'
}

# ✅ 명사 감성 힌트: 등장하면 자동 분류
NOUN_POS_HINTS = {
    '위생','위생적','청결','쾌적','깔끔함','정갈','분위기','아늑함','편안함',
    '가성비','신선도','신선함','배려','세심함','친절','주차','접근성','푸짐함','할인','퀄리티','품질'
}
NOUN_NEG_HINTS = {
    '소음','소란','혼잡','붐빔','대기','웨이팅','불친절','비용','가격대','바가지',
    '냄새','악취','역한냄새','비위생','더러움','위생문제','지저분함',
    '이물질','머리카락','지연','대충','하자','불량',
    '줄어듦','양줄다','양감소','소량'   # “줄어듦/양줄다” 계열
}

# ✅ 강제 분류(무조건 긍/부정)
FORCE_POS = {
    '맛있다','좋다','좋아하다','훌륭하다','괜찮다',
    '담백하다','고소하다','진하다','풍부하다','향긋하다','달콤하다','짭짤하다','쫄깃하다',
    '부드럽다','바삭하다','촉촉하다','신선하다','살살녹다',
    '푸짐하다','넉넉하다','가성비좋다','합리적이다',
    '친절하다','세심하다','성의있다','빠르다',
    '깔끔하다','청결하다','위생적이다','정갈하다',
    '아늑하다','쾌적하다','편안하다',
    '여유롭다','한산하다','접근성좋다','주차편하다',
    '안짜다','간이딱맞다'
}
FORCE_NEG = {
    '맛없다','나쁘다','형편없다','별로다',
    '느끼하다','느글느글','텁텁하다','묽다','밋밋하다','비리다','쓰다','싱겁다','짜다',
    '질기다','눅눅하다','마르다','퍽퍽하다','덜익다','상하다','탄맛나다',
    '부족하다','적다','비싸다','바가지',
    '불친절하다','대충하다','불성의하다','느리다','지연되다',
    '지저분하다','더럽다','비위생적이다','허술하다',
    '시끄럽다','답답하다','불편하다',
    '붐비다','혼잡하다','접근성나쁘다','주차불편하다',
    '냄새나다','역하다','이물질','머리카락','줄어듦','양줄다','양줄어듦'
}

# ----------------------------------
# 문장 내 cue(강조/부정 부사·접두어) 추출
# ----------------------------------
def extract_cues(text: str):
    s = re.sub(r'http\S+|www\.\S+', ' ', str(text))
    s = re.sub(r'[^가-힣0-9\s]', ' ', s)
    s = s.replace('별루','별로')
    pos_cues, neg_cues = set(), set()
    for tok in kiwi.tokenize(s):
        w = tok.lemma or tok.form
        if w in NEG_ADV or w in NEG_CUES or w.startswith('않'):
            neg_cues.add('별로' if w in NEG_ADV else ('않' if w.startswith('않') else w))
        elif w in POS_ADV:
            pos_cues.add(w)
    return pos_cues, neg_cues

# ----------------------------------
# 토큰화 + 부정 접두어 NEG_ 처리 (+ 화이트리스트 명사 수집)
# ----------------------------------
def tokenize_with_neg(text: str):
    text = re.sub(r'http\S+|www\.\S+', ' ', str(text))
    text = re.sub(r'[^가-힣0-9\s]', ' ', text)
    text = text.replace('별루','별로')
    toks = [(t.lemma or t.form, t.tag) for t in kiwi.tokenize(text)]
    out=[]; i=0
    nouns=set()  # 화이트리스트 통과 명사 저장

    while i < len(toks):
        w,p = toks[i]

        # 화이트리스트 명사(NNG) 수집: 메뉴명 등은 기본 제외
        if p == 'NNG' and len(w) > 1:
            if (w in NOUN_WHITELIST) or any(w.startswith(k) or k in w for k in NOUN_WHITELIST):
                nouns.add(w)

        # 부정 cue → 다음 서술어에 NEG_ 부착
        if w in NEG_ADV or w in NEG_CUES or w.startswith('않'):
            if i+1 < len(toks):
                w2,p2 = toks[i+1]
                if p2 in ('VA','VV') and len(w2)>1:
                    out.append('NEG_'+w2); i+=2; continue
            i+=1; continue

        # 서술어만 추출
        if p in ('VA','VV') and len(w)>1:
            out.append(w)
        i+=1

    return out, nouns

# ----------------------------------
# 단어 감성 점수
# ----------------------------------
def polarity(word):
    inv = word.startswith('NEG_')
    if inv: word = word[4:]
    try:
        v = kv.get_vector(word)
    except:
        return None
    s = float(np.dot(_unit(v), SENT_AXIS))
    return -s if inv else s

# ----------------------------------
# 문장 감성 + 키워드 (cue + 명사 힌트 포함)
# ----------------------------------
def sentiment_from_text(text: str, margin=0.15):
    # 1) cue 수집
    pos_cues, neg_cues = extract_cues(text)

    # 2) 서술어 토큰 + 화이트리스트 명사
    toks, nouns_in_text = tokenize_with_neg(text)
    pos, neg = [], []

    for w in toks:
        inv  = w.startswith('NEG_')
        base = w[4:] if inv else w

        # 강제 분류(부호 반영)
        if base in FORCE_POS:
            (neg if inv else pos).append(base);  continue
        if base in FORCE_NEG:
            (pos if inv else neg).append(base);  continue

        # 의미 없는/짧은 토큰 컷
        if base in STOP_LEMMAS: continue
        if len(base) <= 1 or re.fullmatch(r'\d+', base): continue

        s = polarity(w)
        if s is None: continue
        if s >= margin:      pos.append(base)
        elif s <= -margin:   neg.append(base)

    # 3) 명사 힌트로 자동 분류 (화이트리스트에 등장한 명사만)
    pos_hint = nouns_in_text & NOUN_POS_HINTS
    neg_hint = nouns_in_text & NOUN_NEG_HINTS

    # 4) cue와 모델 결과, 명사 힌트 합치기
    pos = ' '.join(sorted(set(pos) | pos_cues | pos_hint))
    neg = ' '.join(sorted(set(neg) | neg_cues | neg_hint))

    # 5) 비율/점수
    denom = len(pos.split()) + len(neg.split())
    ratio = 0.5 if denom == 0 else len(pos.split()) / denom
    return ratio, ratio*5.0, pos, neg

# ----------------------------------
# 메인 파이프라인
# ----------------------------------
def run_pipeline(res_idx: int,
                 base_weight=0.7, sent_weight=0.3,
                 base_fallback=4.2, margin=0.22) -> WordcloudAndRatings:

    # 1) 피드
    query1 = f"""
        SELECT r.res_name, f.res_idx, feed_content, ratings
        FROM t_feed f
        JOIN t_restaurant r ON r.res_idx = f.res_idx
        WHERE f.res_idx = {int(res_idx)};
    """
    feed_df = db_connect(query1, ['res_name','res_idx','feed_content','feed_ratings'])

    # 2) 리뷰(네이버/카카오 제외)
    query2 = f"""
        SELECT res_idx, review_content, ratings AS review_ratings
        FROM t_review
        WHERE res_idx = {int(res_idx)}
          AND mb_id NOT IN ('kakao12345','naver12345');
    """
    review_df = db_connect(query2, ['res_idx','review_content','review_ratings'])

    # 3) 피드에서 가게명 제거
    if not feed_df.empty:
        feed_df['feed_content_clean'] = feed_df.apply(
            lambda r: str(r['feed_content']).replace(str(r['res_name']), '').strip(), axis=1
        )
    else:
        feed_df['feed_content_clean'] = pd.Series(dtype=object)

    # 4) 전처리
    def norm(s):
        s = '' if pd.isna(s) else str(s)
        s = s.replace('□',' ')
        return re.sub(r'\s+',' ',s).strip()

    reviews = review_df.get('review_content', pd.Series(dtype=object)).apply(norm).tolist()
    feeds   = feed_df.get('feed_content_clean', pd.Series(dtype=object)).apply(norm).tolist()
    content_merged = ' '.join([t for t in reviews + feeds if t])

    # 5) 별점 평균
    r_reviews = review_df.get('review_ratings', pd.Series(dtype=float)).astype(float).values
    r_feeds   = feed_df.get('feed_ratings',  pd.Series(dtype=float)).astype(float).values
    all_r = np.concatenate([r_reviews, r_feeds]) if (len(r_reviews) or len(r_feeds)) else np.array([])
    rating_avg = float(np.nanmean(all_r)) if all_r.size else np.nan

    # 6) 감성 분석
    ratio, sent_rating, pos_text, neg_text = sentiment_from_text(content_merged, margin=margin)

    # 7) 최종 평점(별점+감성)
    base = rating_avg if pd.notna(rating_avg) else base_fallback
    final_rating = round(base_weight*float(base) + sent_weight*float(sent_rating), 3)
    final_rating = max(0.0, min(5.0, final_rating))

    # 8) WC용 텍스트 조회
    query_wc = f"""
    SELECT
      r.res_idx,
      (SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
         FROM t_review tr
        WHERE tr.res_idx = r.res_idx AND tr.mb_id = 'naver12345') AS naver_reviews,
      (SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
         FROM t_review tr
        WHERE tr.res_idx = r.res_idx AND tr.mb_id = 'kakao12345') AS kakao_reviews,
      (SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
         FROM t_review tr
        WHERE tr.res_idx = r.res_idx AND tr.mb_id NOT IN ('naver12345','kakao12345')) AS wagunyam_review,
      (SELECT GROUP_CONCAT(feed_content SEPARATOR ' ')
         FROM t_feed tf
        WHERE tf.res_idx = r.res_idx) AS wagunyam_feed
    FROM (
      SELECT DISTINCT res_idx FROM t_review
      UNION
      SELECT DISTINCT res_idx FROM t_feed
    ) r
    WHERE r.res_idx = {int(res_idx)};
    """
    wc_df = db_connect(
        query_wc,
        ['res_idx','naver_reviews','kakao_reviews','wagunyam_review','wagunyam_feed']
    )

    # 9) 그룹 텍스트 합치기
    naver = str(wc_df.at[0,'naver_reviews'] or '') if not wc_df.empty else ''
    kakao = str(wc_df.at[0,'kakao_reviews'] or '') if not wc_df.empty else ''
    wgn_r = str(wc_df.at[0,'wagunyam_review'] or '') if not wc_df.empty else ''
    wgn_f = str(wc_df.at[0,'wagunyam_feed'] or '') if not wc_df.empty else ''

    naver_kakao_reviews = re.sub(r'\s+',' ', (naver + ' ' + kakao)).strip()
    wgn_reviews         = re.sub(r'\s+',' ', (wgn_f + ' ' + wgn_r)).strip()

    # 10) 각 그룹별 키워드
    _, _, pos_nk, neg_nk = sentiment_from_text(naver_kakao_reviews, margin=margin)
    _, _, pos_wg, neg_wg = sentiment_from_text(wgn_reviews,         margin=margin)


    result = WordcloudAndRatings(
        nk_positive_wc=text_to_base64_wordcloud(pos_nk),
        nk_negative_wc=text_to_base64_wordcloud(neg_nk),
        wgn_positive_wc=text_to_base64_wordcloud(pos_wg),
        wgn_negative_wc=text_to_base64_wordcloud(neg_wg),
        wgn_ratings=final_rating
    )

    return result