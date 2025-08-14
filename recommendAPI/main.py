from fastapi import FastAPI, Body, Query # FastAPI : 인공지능 서버를 별도로 구축해서 서비스에 통합할 수 있는 백엔드 프레임워크 
from typing import List # typing : 파이썬의 타입 힌트를 위한 도구 / List : List 타입을 명확하게 표현하기 위해 사용함
from fastapi.responses import JSONResponse # JSONResponse : FastAPI에서 응답을 보낼 때 직접 JSON 형식으로 된 응답을 보낼 수 있도록 도와주는 클래스
import uvicorn
import nest_asyncio
from urllib.parse import unquote
from feed_recommendation import get_recommendations_for_user
from feed_searching import show_recommendation_result
from making_wordclouds import run_pipeline
from res_searching import prepare_data, recommend_with_reviewscore_auto
from models import FeedForSearch, WordcloudAndRatings # 클래스들이 모여있는 파일

# ------------------ FastAPI 앱 객체 ------------------

app = FastAPI() # FastAPI 클래스를 활용해서 만든 인스턴스 app

# ------------------ API 엔드포인트 ------------------

# 엔드포인트 : 클라이언트가 백엔드 서버에 요청을 보낼 수 있는 URL 경로 (ex : /receive_logs_and_feeds 경로로 post 메서드를 활용한 엔드포인트)

nest_asyncio.apply() # FastAPI, Uvicorn, asyncio 코드를 실행할 때 필수적, 같은 이벤트 루프 안에서 여러 번 비동기 함수 실행이 가능해짐

# --- 추천 음식점 데이터 준비 ---

df = None
menu_matrix = None
tag_matrix = None
text_data_matrix = None
menu_vectorizer = None
tag_vectorizer = None
text_data_vectorizer = None
menu_embeddings = None
category_map = None
info_keywords = None
keyword_map = None

@app.on_event("startup")
def startup_event():

    print("[음식점 추천 알고리즘] 실행 준비 시작!")
    
    global df, menu_matrix, tag_matrix, text_data_matrix
    global menu_vectorizer, tag_vectorizer, text_data_vectorizer
    global menu_embeddings, category_map, info_keywords, keyword_map

    (df, menu_matrix, tag_matrix, text_data_matrix,
        menu_vectorizer, tag_vectorizer, text_data_vectorizer,
        menu_embeddings, category_map, info_keywords, keyword_map
    ) = prepare_data()

    print("[음식점 추천 알고리즘] 실행 준비 완료!")

# --- 추천 음식점 idx 리스트 반환 ---
@app.get("/receive_res", response_model=List[int])
async def receive_res(query: str = Query(..., description="검색어")):

    print("=== /receive_res 호출됨 ===")
    print("받은 키워드 : ", query)
    decoded_query = unquote(query)
    print("받은 키워드 (디코딩 후): ", decoded_query)

    # 추천 알고리즘 호출
    res_idx_list = recommend_with_reviewscore_auto(
        query=decoded_query,
        df=df,
        menu_matrix=menu_matrix,
        tag_matrix=tag_matrix,
        text_data_matrix=text_data_matrix,
        menu_vectorizer=menu_vectorizer,
        tag_vectorizer=tag_vectorizer,
        text_data_vectorizer=text_data_vectorizer,
        menu_embeddings=menu_embeddings,
        alpha=0.45, beta=0.1, gamma=0.25, delta=0.2,
        keyword_bonus=1.2, text_data_bonus=1.0, min_menu_sim=0.01,
        category_map=category_map, info_keywords=info_keywords, keyword_map=keyword_map
    )

    print("추천된 음식점 리스트 : ", res_idx_list)
    
    return res_idx_list


# --- 레스토랑 인덱스 번호 받아서 워드클라우드 제작 / 와구냠 평점 생성 ---
@app.post("/receive_review")
async def receive_review(res_idx: int) -> WordcloudAndRatings:
    print("=== /receive_review 호출됨 ===")

    # 함수 호출
    result = run_pipeline(res_idx)

    print("=== /receive_review 처리 완료 ===\n")

    return result

@app.post("/receive_feed_recommendation")
async def receive_feed_recommendation(mb_id: str = Body(..., embed=True)):

    print("=== /receive_feed_recommendation 호출됨 ===")
    print("받은 아이디 :", mb_id)

    # 추천 계산 → (사후) DB 반영까지 모듈에서 처리
    recommended_feed_idx = get_recommendations_for_user(user_id=mb_id, max_count=20)

    print("=== /receive_feed_recommendation 종료 ===")

    # 응답 (리턴 타입/미디어 타입은 유지)
    return JSONResponse(content=recommended_feed_idx,
                        media_type="application/json; charset=utf-8")


@app.post("/receive_feed_for_search")
async def receive_feed_for_search(
    feed_list: List[FeedForSearch],  # JSON 배열 형태로 feed 리스트 받음
    query: str = Query(..., description="검색어")  # 쿼리 파라미터로 검색어 받음
):
    print("=== /receive_feed_for_search 호출됨 ===")
    print(f"받은 피드 개수: {len(feed_list)}")
    print("받은 키워드 : ", query)
    decoded_query = unquote(query)
    print("받은 키워드 (디코딩 후): ", decoded_query)

    # feed_list는 pydantic 객체 리스트, dict 리스트로 변환
    feed_dict_list = [feed.dict() for feed in feed_list]

    # 검색 함수 호출 (검색어, feed 리스트 전달)
    searched_feed_idx = show_recommendation_result(feed_dict_list, decoded_query)

    print(f"검색된 피드 idx 개수: {len(searched_feed_idx)}")
    print(f"검색된 피드 idx: {searched_feed_idx[:10]}")
    print("=== /receive_feed_for_search 처리 완료 ===\n")

    return searched_feed_idx