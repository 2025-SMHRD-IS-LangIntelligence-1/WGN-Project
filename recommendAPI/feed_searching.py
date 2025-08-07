from typing import List, Dict
import pandas as pd
import re
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
