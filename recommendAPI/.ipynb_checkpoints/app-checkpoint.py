from fastapi import FastAPI # FastAPI : 인공지능 서버를 별도로 구축해서 서비스에 통합할 수 있는 백엔드 프레임워크 
from typing import List # typing : 파이썬의 타입 힌트를 위한 도구 / List : List 타입을 명확하게 표현하기 위해 사용함
from fastapi.responses import JSONResponse # JSONResponse : FastAPI에서 응답을 보낼 때 직접 JSON 형식으로 된 응답을 보낼 수 있도록 도와주는 클래스

from feed_recommendation import recommend_feed
from feed_searching import search_feed
from making_wordclouds import make_wordclouds
from models import LogsAndFeeds, FeedForSearch, Review # 클래스들이 모여있는 파일

# ------------------ FastAPI 앱 객체 ------------------

app = FastAPI() # FastAPI 클래스를 활용해서 만든 인스턴스 app

# ------------------ API 엔드포인트 ------------------

# 엔드포인트 : 클라이언트가 백엔드 서버에 요청을 보낼 수 있는 URL 경로 (ex : /receive_logs_and_feeds 경로로 post 메서드를 활용한 엔드포인트)

@app.post("/receive_logs_and_feeds")
async def receive_logs_and_feeds(data: LogsAndFeeds): # data : 클라이언트(Spring 서버)로부터 LogsAndFeeds 클래스 형태로 파싱해서 받은 데이터
   
    # 데이터가 잘 들어왔는지 확인하는 프린트문
    
    print("=== /receive_logs_and_feeds 호출됨 ===")
    
    print(f"받은 로그 개수: {len(data.logs)}") 
    for i, log in enumerate(data.logs[:3]):  # 샘플 3개 출력
        print(f"  로그 {i+1}: mb_id={log.mb_id}, res_idx={log.res_idx}, action={log.action_type}")
        
    print(f"받은 피드 개수: {len(data.feeds)}")
    for i, feed in enumerate(data.feeds[:3]):  # 샘플 3개 출력
        print(f"  피드 {i+1}: feed_idx={feed.feed_idx}, res_idx={feed.res_idx}, likes={feed.feed_likes}")

    # 추천 알고리즘 함수 실행하고 그 결과를 recommended_feed_ids에 저장
    
    recommended_feed_idx = recommend_feed(
        [log.dict() for log in data.logs], # pydantic 객체를 딕셔너리로 변환
        [feed.dict() for feed in data.feeds] # pydantic 객체를 딕셔너리로 변환
    )
    
    print(f"추천된 피드 idx 개수: {len(recommended_feed_idx)}")
    print(f"추천된 피드 idx : {recommended_feed_idx[:10]}")  # 최대 10개만 출력
    print("=== /receive_logs_and_feeds 처리 완료 ===\n")

    return JSONResponse(content={
        "recommended_feed_ids": recommended_feed_idx
    }, media_type="application/json; charset=utf-8")

@app.post("/receive_feed_for_search")
async def receive_feed_for_search(data: List[FeedForSearch]):
   
    # 데이터가 잘 들어왔는지 확인하는 프린트문
    
    print("=== /receive_feed_for_search 호출됨 ===")

    print(f"받은 피드 개수: {len(data)}")

    # 검색 알고리즘 함수 실행하고 그 결과를 searched_feed_idx에 저장
    # feed를 딕셔너리 형태로 만든 리스트를 매개변수로 받음
    searched_feed_idx = search_feed([feed.dict() for feed in data])
    
    print(f"검색된 피드 idx 개수: {len(searched_feed_idx)}")
    print(f"검색된 피드 idx: {searched_feed_idx[:10]}")  # 최대 10개만 출력
    print("=== /receive_feed_for_search 처리 완료 ===\n")

    return searched_feed_idx

@app.post("/receive_review")
async def receive_review(data: List[Review]):
   
    # 데이터가 잘 들어왔는지 확인하는 프린트문
    
    print("=== /receive_review 호출됨 ===")

    print("받은 리뷰 개수 : ", len(data))

    # 워드클라우드 제작 함수 실행하고 그 결과를 저장
    wordclouds = make_wordclouds(data)
    
    print(f"만들어진 wordclouds: ", wordclouds)
    
    print("=== /receive_review 처리 완료 ===\n")

    return JSONResponse(content=wordclouds.dict(), media_type="application/json; charset=utf-8")