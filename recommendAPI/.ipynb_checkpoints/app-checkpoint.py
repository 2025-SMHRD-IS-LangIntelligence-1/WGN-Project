from fastapi import FastAPI # FastAPI : 인공지능 서버를 별도로 구축해서 서비스에 통합할 수 있는 백엔드 프레임워크 
from pydantic import BaseModel # pydantic : 데이터 검증과 설정 관리를 위한 Python 라이브러리
from typing import List # typing : 파이썬의 타입 힌트를 위한 도구 / List : List 타입을 명확하게 표현하기 위해 사용함
from fastapi.responses import JSONResponse # JSONResponse : FastAPI에서 응답을 보낼 때 직접 JSON 형식으로 된 응답을 보낼 수 있도록 도와주는 클래스
from feed_recommendation import recommend_feed
from feed_searching import search_feed

# ------------------ 데이터 모델 정의 ------------------

class Log(BaseModel): # BaseModel을 활용하면 잘못된 데이터가 들어왔을 때 자동으로 422 에러를 띄워줌 (데이터 검증)
    # 사용자 로그를 저장하는 클래스
    log_idx: int
    mb_id: str
    res_idx: int
    res_category: str
    res_tag: str
    action_type: str
    created_at: str

class Feed(BaseModel):
    # 추천 후보 피드를 저장하는 클래스
    feed_idx: int
    res_idx: int
    feed_likes: int
    res_category: str
    res_tag: str

class LogsAndFeeds(BaseModel):
    # Spring 요청 데이터를 저장하는 클래스
    logs: List[Log] # Log 인스턴스가 List 형태로 저장됨
    feeds: List[Feed] # Feed 인스턴스가 List 형태로 저장됨

class FeedForSearch(BaseModel):
    # 검색을 위한 후보 피드를 저장하는 클래스
    feed_idx: int
    feed_likes: int
    res_tag : str
    feed_content: str

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