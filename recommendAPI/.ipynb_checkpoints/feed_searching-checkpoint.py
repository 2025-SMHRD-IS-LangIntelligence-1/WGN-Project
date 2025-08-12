import pandas as pd
import re
<<<<<<< HEAD
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer

# ✅ BERT 모델 로드
bert_model = SentenceTransformer("snunlp/KR-SBERT-V40K-klueNLI-augSTS")


# ✅ 특수문자 제거 함수
def clean_text(text: str) -> str:
    text = str(text)
    text = re.sub(r'[^\w가-힣\s]', ' ', text)  # 특수문자 제거
    text = re.sub(r'\s+', ' ', text).strip()  # 중복 공백 제거
    return text


# ✅ TF-IDF 유사도 계산
def get_tfidf_similarity(df: pd.DataFrame, query: str, column: str) -> List[float]:
    corpus = df[column].fillna("").tolist()
    tfidf = TfidfVectorizer()
    matrix = tfidf.fit_transform(corpus + [query])
    sim = cosine_similarity(matrix[-1], matrix[:-1])[0]
    return sim


# ✅ BERT 유사도 계산
def get_bert_similarity(df: pd.DataFrame, query: str, column: str) -> List[float]:
    corpus = df[column].fillna("").tolist()
    sentences = corpus + [query]
    embeddings = bert_model.encode(sentences, convert_to_tensor=True)
    sim = cosine_similarity([embeddings[-1].cpu().numpy()], embeddings[:-1].cpu().numpy())[0]
    return sim


# ✅ 태그 유사도 (TF-IDF)
def get_tag_similarity(df: pd.DataFrame, query: str) -> List[float]:
    tag_texts = df['res_tag'].fillna("").apply(clean_text)
    tfidf = TfidfVectorizer()
    matrix = tfidf.fit_transform(tag_texts.tolist() + [query])
    sim = cosine_similarity(matrix[-1], matrix[:-1])[0]
    return sim


# ✅ 추천 메인 함수
def search_feed(feeds: List[Dict], query: str) -> List[int]:
    print("=== search_feed 함수 실행 ===")
    feed_df = pd.DataFrame(feeds)

    # 전처리
    feed_df['feed_content'] = feed_df['feed_content'].fillna("").apply(clean_text)
    feed_df['res_tag'] = feed_df['res_tag'].fillna("").apply(clean_text)
    query_clean = clean_text(query)

    # 1단계: 가게명 완전일치
    exact_match = feed_df[feed_df['feed_content'] == query_clean]
    if not exact_match.empty:
        print("[1단계] 가게명 완전일치")
        return exact_match.sort_values(by='feed_likes', ascending=False)['feed_idx'].tolist()

    # 2단계: 가게명 부분일치
    partial_match = feed_df[feed_df['feed_content'].str.contains(query_clean, case=False, na=False)]
    if not partial_match.empty:
        print("[2단계] 가게명 부분일치")
        return partial_match.sort_values(by='feed_likes', ascending=False)['feed_idx'].tolist()

    # 3단계: 유사도 기반 추천
    print("[3단계] 가게명 완전 불일치 → 유사도 기반 추천")

    bert_sim = get_bert_similarity(feed_df, query_clean, column='feed_content')
    tfidf_sim = get_tfidf_similarity(feed_df, query_clean, column='feed_content')
    tag_sim = get_tag_similarity(feed_df, query_clean)

    # 점수 조합
    feed_df['score'] = (
        0.5 * np.array(bert_sim) +
        0.2 * np.array(tfidf_sim) +
        0.3 * np.array(tag_sim)
    )

    # score 상위 10 → feed_likes 기준 정렬
    top10_df = feed_df.sort_values(by='score', ascending=False).head(10)
    top10_df = top10_df.sort_values(by='feed_likes', ascending=False)

    result = top10_df['feed_idx'].tolist()
    print("✅ 추천된 feed_idx:", result)
    return result


# 테스트 쿼리 입력
query = "버거킹"

# 함수 실행
recommended = search_feed(feeds, query)

# 결과 출력
print("\n✅ 최종 추천된 feed_idx 목록:", recommended)

# 추천 결과 상세 보기
print("\n✅ 추천 피드 상세:")
pd.DataFrame(feeds).set_index("feed_idx").loc[recommended][["feed_content", "res_tag", "feed_likes"]]
=======
from typing import List, Dict
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer
from konlpy.tag import Okt

# 전역 객체 및 불용어 세팅
EXCLUDE_NOUNS = {"집", "맛집", "가게", "전문점"}
bert_model = SentenceTransformer("snunlp/KR-SBERT-V40K-klueNLI-augSTS")
okt = Okt()

def show_recommendation_result(feeds: List[Dict], query, top_n=10) -> List[int] :

    print("=== show_recommendation_result 함수 실행 ===")
    
    # 스프링에서 넘어온 검색 후보 피드 정보를 데이터프레임화
    df = pd.DataFrame(feeds)

    result = search_feed(df, query, top_n=top_n, bert_threshold=0.5)
    
    print(f"\n[검색어: '{query}'] 추천 feed_idx: {results}")
    
    if result:
        print(df[df['feed_idx'].isin(results)][['feed_idx', 'feed_content', 'res_tag', 'feed_likes']])
    else:
        print("검색 결과 없음!")

    return result

def is_real_noun(word):
    return not re.fullmatch(r"[ㄱ-ㅎㅏ-ㅣ]+", word)

def extract_nouns(text: str) -> List[str]:
    text = re.sub(r"[^\uAC00-\uD7A3a-zA-Z0-9\s]", "", str(text))
    nouns = okt.nouns(text)
    nouns = [n for n in nouns if n not in EXCLUDE_NOUNS and is_real_noun(n)]
    return nouns

def extract_hash_tags(text: str) -> List[str]:
    if not isinstance(text, str):
        return []
    tags = [tag.lstrip("#") for tag in re.findall(r"#\w+", text)]
    return [t for t in tags if t not in EXCLUDE_NOUNS]

def extract_tag_list(tag_text: str) -> List[str]:
    if not isinstance(tag_text, str):
        return []
    return [n for n in re.split(r'[\s,]+', tag_text) if n]

def contains_any_noun(text, nouns):
    if not isinstance(text, str) or not nouns:
        return False
    return any(n in text for n in nouns)

def get_bert_similarity(df: pd.DataFrame, query: str, column: str) -> List[float]:
    corpus = df[column].fillna("").tolist()
    sentences = corpus + [query]
    embeddings = bert_model.encode(sentences, convert_to_tensor=True)
    sim = cosine_similarity([embeddings[-1].cpu().numpy()], embeddings[:-1].cpu().numpy())[0]
    return sim

def search_feed(df: pd.DataFrame, query: str, top_n: int = 10, bert_threshold: float = 0.5) -> List[int]:
    df = df.copy()
    df['hash_tags'] = df['feed_content'].apply(extract_hash_tags)
    df['tag_list'] = df['res_tag'].apply(extract_tag_list)
    df['content_nouns'] = df['feed_content'].apply(extract_nouns)
    query_nouns = extract_nouns(query)
    query_clean = " ".join(query_nouns)
    query_jeon_only = (query_clean == "전")

    # 1. 가게명 완전일치 (딱 맞는 거만)
    rows_by_exact = df[df['feed_content'] == query]
    if not rows_by_exact.empty:
        top = rows_by_exact.sort_values(by='feed_likes', ascending=False).head(top_n)
        return top['feed_idx'].tolist()

    # 2. 가게명 부분일치
    rows_by_contains = df[df['feed_content'].str.contains(query, case=False, na=False)]
    if not rows_by_contains.empty:
        top = rows_by_contains.sort_values(by='feed_likes', ascending=False).head(top_n)
        return top['feed_idx'].tolist()

    # 3. 명사 기반 후보군 (본문/태그/해시태그에 분위기 등 명사 하나라도 포함된 곳)
    def row_match(row):
        return (
            contains_any_noun(row['feed_content'], query_nouns)
            or contains_any_noun(row['res_tag'], query_nouns)
            or any(contains_any_noun(tag, query_nouns) for tag in row['hash_tags'])
        )
    candidates = df[df.apply(row_match, axis=1)]
    if not candidates.empty:
        candidates = candidates.copy()
        candidates['score'] = get_bert_similarity(candidates, query_clean, column='feed_content')
        candidates = candidates[candidates['score'] >= bert_threshold]
        top = candidates.sort_values(by='score', ascending=False).head(top_n)
        top = top.sort_values(by='feed_likes', ascending=False)
        return top['feed_idx'].tolist()

    # 4. '전' 단독 특수처리
    if query_jeon_only:
        def jeon_tag_only(row):
            return '전' in row['tag_list']
        jeon_matched = df[df.apply(jeon_tag_only, axis=1)]
        if not jeon_matched.empty:
            jeon_matched = jeon_matched.copy()
            jeon_matched['score'] = get_bert_similarity(jeon_matched, query_clean, column='res_tag')
            top = jeon_matched.sort_values(by='score', ascending=False).head(top_n)
            top = top.sort_values(by='feed_likes', ascending=False)
            return top['feed_idx'].tolist()

    # 5. 전체 쿼리로 부분일치(fallback, BERT)
    rows_by_query = df[df['feed_content'].str.contains(query, case=False, na=False)]
    if not rows_by_query.empty:
        rows_by_query = rows_by_query.copy()
        rows_by_query['score'] = get_bert_similarity(rows_by_query, query, column='feed_content')
        top = rows_by_query.sort_values(by='score', ascending=False).head(top_n)
        top = top.sort_values(by='feed_likes', ascending=False)
        return top['feed_idx'].tolist()

    # 6. res_tag fallback (명사 포함 태그)
    fallback = df[df['res_tag'].str.contains('|'.join(query_nouns), na=False)] if query_nouns else pd.DataFrame()
    if not fallback.empty:
        fallback = fallback.copy()
        fallback['score'] = get_bert_similarity(fallback, query, column='res_tag')
        top = fallback.sort_values(by='score', ascending=False).head(top_n)
        top = top.sort_values(by='feed_likes', ascending=False)
        return top['feed_idx'].tolist()

    # 7. 진짜 무관한 경우
    return []


>>>>>>> ee3d906e21d21ddd056258379404a7ce46130410
