import os, re, base64, gzip, shutil, requests
import numpy as np
import pandas as pd
import pymysql
from io import BytesIO
from pathlib import Path
from wordcloud import WordCloud
from kiwipiepy import Kiwi
from gensim.models.fasttext import load_facebook_vectors

# ----------------------------------
# 공용: DB
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
    wc = WordCloud(width=400, height=400, background_color="white",
                   font_path=_pick_korean_font())
    wc.generate(text or " ")
    buf = BytesIO()
    wc.to_image().save(buf, format="PNG")
    return base64.b64encode(buf.getvalue()).decode()

# ----------------------------------
# 공용: fastText & 감성 축
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

if 'kv' not in globals():
    FT_BIN  = Path(r"C:\emb\cc.ko.300.bin")  # 원하는 경로로 변경 가능
    BIN_URL = "https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.ko.300.bin.gz"
    FT_BIN = ensure_fasttext_bin(FT_BIN, BIN_URL)
    kv = load_facebook_vectors(str(FT_BIN))

def _unit(v): n = np.linalg.norm(v); return v/n if n else v

def build_axis(kv, pairs=[('좋다','나쁘다'), ('만족','불만')]):
    axes=[]
    for a,b in pairs:
        try: axes.append(_unit(kv.get_vector(a)-kv.get_vector(b)))
        except: pass
    if not axes: raise RuntimeError("감성 앵커 벡터를 찾지 못함")
    return _unit(np.mean(axes, axis=0))

if 'SENT_AXIS' not in globals():
    SENT_AXIS = build_axis(kv)

kiwi = Kiwi()
NEG_CUES = {'안','못','전혀','아니','아닌','않','없'}
NEG_ADV  = {'별로','그닥','그다지','영','별루'}

def tokenize_with_neg(text: str):
    text = re.sub(r'http\S+|www\.\S+', ' ', str(text))
    text = re.sub(r'[^가-힣0-9\s]', ' ', text)
    text = text.replace('별루','별로')
    toks = [(t.lemma or t.form, t.tag) for t in kiwi.tokenize(text)]
    out=[]; i=0
    while i < len(toks):
        w,p = toks[i]
        if w in NEG_ADV or w in NEG_CUES or w.startswith('않'):
            if i+1 < len(toks):
                w2,p2 = toks[i+1]
                if p2 in ('VA','VV') and len(w2)>1:
                    out.append('NEG_'+w2); i+=2; continue
            out.append('별로' if w in NEG_ADV else w); i+=1; continue
        if p in ('VA','VV') and len(w)>1:
            out.append(w)
        i+=1
    return out

def polarity(word):
    inv = word.startswith('NEG_')
    if inv: word = word[4:]
    try: v = kv.get_vector(word)
    except: return None
    s = float(np.dot(_unit(v), SENT_AXIS))
    return -s if inv else s

def sentiment_from_text(text: str, margin=0.05):
    toks = tokenize_with_neg(text)
    pos, neg = [], []
    for w in toks:
        s = polarity(w)
        if s is None: continue
        if s >= margin: pos.append(w.replace('NEG_',''))
        elif s <= -margin: neg.append(w.replace('NEG_',''))
    ratio = 0.5 if (len(pos)+len(neg))==0 else len(pos)/(len(pos)+len(neg))
    return ratio, ratio*5.0, ' '.join(sorted(set(pos))), ' '.join(sorted(set(neg)))

# ----------------------------------
# 통합 파이프라인 (res_idx 하나 전달)
# ----------------------------------
def run_pipeline(res_idx: int, base_weight=0.7, sent_weight=0.3, base_fallback=4.2, margin=0.05) -> WordcloudAndRatings:
    query1 = f"""
        SELECT r.res_name, f.res_idx, feed_content, ratings
        FROM t_feed f
        JOIN t_restaurant r ON r.res_idx = f.res_idx
        WHERE f.res_idx = {res_idx};
    """
    feed_df = db_connect(query1, ['res_name','res_idx','feed_content','feed_ratings'])

    query2 = f"""
        SELECT res_idx, review_content, ratings AS review_ratings
        FROM t_review
        WHERE res_idx = {res_idx}
          AND mb_id NOT IN ('kakao12345','naver12345');
    """
    review_df = db_connect(query2, ['res_idx','review_content','review_ratings'])

    # 2) 가게명 제거 + content_merged & rating_avg
    if not feed_df.empty:
        feed_df['feed_content_clean'] = feed_df.apply(
            lambda r: str(r['feed_content']).replace(str(r['res_name']), '').strip(), axis=1
        )
    else:
        feed_df['feed_content_clean'] = pd.Series(dtype=object)

    def norm(s):
        s = '' if pd.isna(s) else str(s)
        s = s.replace('□',' ')
        return re.sub(r'\s+',' ',s).strip()

    reviews = review_df.get('review_content', pd.Series(dtype=object)).apply(norm).tolist()
    feeds   = feed_df.get('feed_content_clean', pd.Series(dtype=object)).apply(norm).tolist()
    content_merged = ' '.join([t for t in reviews + feeds if t])

    r_reviews = review_df.get('review_ratings', pd.Series(dtype=float)).astype(float).values
    r_feeds   = feed_df.get('feed_ratings',  pd.Series(dtype=float)).astype(float).values
    all_r = np.concatenate([r_reviews, r_feeds]) if (len(r_reviews) or len(r_feeds)) else np.array([])
    rating_avg = float(np.nanmean(all_r)) if all_r.size else np.nan

    # 3) 감성(0~5) + 최종 별점
    ratio, sent_rating, pos_text, neg_text = sentiment_from_text(content_merged, margin=margin)
    base = rating_avg if pd.notna(rating_avg) else base_fallback
    final_rating = round(base_weight*float(base) + sent_weight*float(sent_rating), 3)
    final_rating = max(0.0, min(5.0, final_rating))

    # 4) NK/WGN 텍스트 모아서 워드클라우드
    query_wc = """
    SELECT
    r.res_idx,

    (
        SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
        FROM t_review tr
        WHERE tr.res_idx = r.res_idx
          AND tr.mb_id = 'naver12345'
    ) AS naver_reviews,

    (
        SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
        FROM t_review tr
        WHERE tr.res_idx = r.res_idx
          AND tr.mb_id = 'kakao12345'
    ) AS kakao_reviews,

    (
        SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
        FROM t_review tr
        WHERE tr.res_idx = r.res_idx
          AND tr.mb_id NOT IN ('naver12345', 'kakao12345')
    ) AS wagunyam_review,

    (
        SELECT GROUP_CONCAT(feed_content SEPARATOR ' ')
        FROM t_feed tf
        WHERE tf.res_idx = r.res_idx
    ) AS wagunyam_feed

    FROM
        (
            SELECT DISTINCT res_idx FROM t_review
            UNION
            SELECT DISTINCT res_idx FROM t_feed
        ) r
    
    WHERE r.res_idx = #{res_idx};
    """.replace("#{res_idx}", str(res_idx))

    wc_df = db_connect(
        query_wc,
        ['res_idx','naver_reviews','kakao_reviews','wagunyam_review','wagunyam_feed']
    )

    # 텍스트 합치기
    naver = str(wc_df.at[0,'naver_reviews'] or '') if not wc_df.empty else ''
    kakao = str(wc_df.at[0,'kakao_reviews'] or '') if not wc_df.empty else ''
    wgn_r = str(wc_df.at[0,'wagunyam_review'] or '') if not wc_df.empty else ''
    wgn_f = str(wc_df.at[0,'wagunyam_feed'] or '') if not wc_df.empty else ''

    naver_kakao_reviews = re.sub(r'\s+',' ', (naver + ' ' + kakao)).strip()
    wgn_reviews         = re.sub(r'\s+',' ', (wgn_f + ' ' + wgn_r)).strip()

    # 간단 감성 토큰으로 긍/부 텍스트 뽑아 워드클라우드 생성
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