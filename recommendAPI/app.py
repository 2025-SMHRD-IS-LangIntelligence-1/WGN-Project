from fastapi import FastAPI # FastAPI : 인공지능 서버를 별도로 구축해서 서비스에 통합할 수 있는 백엔드 프레임워크 
from pydantic import BaseModel # pydantic : 데이터 검증과 설정 관리를 위한 Python 라이브러리
from typing import List # typing : 파이썬의 타입 힌트를 위한 도구 / List : List 타입을 명확하게 표현하기 위해 사용함
from fastapi.responses import JSONResponse # JSONResponse : FastAPI에서 응답을 보낼 때 직접 JSON 형식으로 된 응답을 보낼 수 있도록 도와주는 클래스
import ast # Abstract Syntax Trees : 문자열로 되어 있는 파이썬 표현식을 실제 파이썬 객체로 안전하게 변환 (eval 대신 사용 가능, 보안 중시)
import pandas as pd
import numpy as np

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

class RequestData(BaseModel):
    # Spring 요청 데이터를 저장하는 클래스
    logs: List[Log] # Log 인스턴스가 List 형태로 저장됨
    feeds: List[Feed] # Feed 인스턴스가 List 형태로 저장됨

# ------------------ FastAPI 앱 객체 ------------------

app = FastAPI() # FastAPI 클래스를 활용해서 만든 인스턴스 app

# ------------------ API 엔드포인트 ------------------

# 엔드포인트 : 클라이언트가 백엔드 서버에 요청을 보낼 수 있는 URL 경로 (ex : /receive_logs_and_feeds 경로로 post 메서드를 활용한 엔드포인트)

@app.post("/receive_logs_and_feeds")
async def receive_logs_and_feeds(data: RequestData): # data : 클라이언트(Spring 서버)로부터 RequestData 클래스 형태로 파싱해서 받은 데이터
   
    # 데이터가 잘 들어왔는지 확인하는 프린트문
    
    print("=== /receive_logs_and_feeds 호출됨 ===")
    
    print(f"받은 로그 개수: {len(data.logs)}") 
    for i, log in enumerate(data.logs[:3]):  # 샘플 3개 출력
        print(f"  로그 {i+1}: mb_id={log.mb_id}, res_idx={log.res_idx}, action={log.action_type}")
        
    print(f"받은 피드 개수: {len(data.feeds)}")
    for i, feed in enumerate(data.feeds[:3]):  # 샘플 3개 출력
        print(f"  피드 {i+1}: feed_idx={feed.feed_idx}, res_idx={feed.res_idx}, likes={feed.feed_likes}")

    # 추천 알고리즘 함수 실행하고 그 결과를 recommended_feed_ids에 저장
    
    recommended_feed_ids = recommend_feed(
        [log.dict() for log in data.logs], # pydantic 객체를 딕셔너리로 변환
        [feed.dict() for feed in data.feeds] # pydantic 객체를 딕셔너리로 변환
    )
    
    print(f"추천된 피드 ID 개수: {len(recommended_feed_ids)}")
    print(f"추천된 피드 IDs: {recommended_feed_ids[:10]}")  # 최대 10개만 출력
    print("=== /receive_logs_and_feeds 처리 완료 ===\n")

    return JSONResponse(content={
        "recommended_feed_ids": recommended_feed_ids
    }, media_type="application/json; charset=utf-8")


# ------------------ 추천 알고리즘 ------------------
    
def recommend_score_and_priority(row, top10_tags_dict, top_tags, top_tag_category):
    score = 0.0
    matched_tags = []
    best_priority = float('inf')

    for tag in row['res_tag']:
        if tag in top10_tags_dict:
            tag_score, tag_cat, tag_rank = top10_tags_dict[tag]
            matched_tags.append(tag)
            score += tag_score
            if tag_cat == row['res_category']:
                score += 0.2 * tag_score
            if tag_rank < best_priority:
                best_priority = tag_rank

    score += row['feed_likes'] * 0.03
    if any(tag in top_tags for tag in row['res_tag']):
        score += 5
    if best_priority == 1 and top_tag_category and row['res_category'] == top_tag_category:
        score += 1

    if best_priority == float('inf'):
        best_priority = 999

    return pd.Series([score, matched_tags, best_priority])


def recommend_feed(log_dicts: List[dict], feed_dicts: List[dict]) -> List[int]: # 매개변수 -> 반환타입

    print("recommend_feed 함수 시작")

    # 로그, 피드 데이터를 DataFrame으로 변환
    log_df = pd.DataFrame(log_dicts)
    feed_df = pd.DataFrame(feed_dicts)

    print(f"로그 데이터 개수: {len(log_df)}")
    print(f"피드 데이터 개수: {len(feed_df)}")

    # mb_id 컬럼 제거
    # 어차피 한 사람의 사용자 로그이기 때문에 mb_id는 불필요
    log_df = log_df.drop(columns=['mb_id'], errors='ignore')

    # log_df 음식점 태그 분리
    # "스테이크 스프 불고기" 형태로 되어 있음 -> "스테이크", "스프", "불고기"
    log_df['res_tag'] = log_df['res_tag'].apply(lambda x: x.split())

    # 점수 계산
    # 사용자의 행동에 가중치를 부여해서 점수 컬럼으로 만듦
    weights = {"글작성": 2, "찜": 1.5, "검색": 1.5, "좋아요": 1, "클릭": 1}
    log_df['score'] = log_df['action_type'].map(weights).fillna(0) # weights 딕셔너리를 각각의 action_type컬럼에 mapping, null값은 0으로 처리

    # 태그 별로 행 분리
    # 리스트 형태로 되어 있는 태그를 분리해서 별도의 행으로 만든 새로운 데이터프레임 생성
    exploded_df = log_df.explode('res_tag')

    # Top 10 태그 (카테고리 포함)
    # 동일한 tag끼리 그룹화해서 점수 합계를 구한 새로운 데이터프레임 생성
    top10_tags = (
        exploded_df.groupby(['res_tag', 'res_category'])['score'] # 2개의 컬럼의 값을 확인해서 전부 동일하면 하나의 튜플(그룹)으로 묶어주고 score 컬럼 선택 
        .sum() # 각 그룹의 score 값을 모두 더함
        .reset_index() # groupby하면 멀티인덱싱이 됨, 멀티인덱싱 해제하고 일반 컬럼 형태로 변경
        .sort_values('score', ascending=False) # 내림차순 정렬
        .head(10) # 상위 10개 선정
    )

    print(f"top10_tags 행 개수: {len(top10_tags)}")
    print(top10_tags)

    # feed_df 음식점 태그 분리
    feed_df['res_tag'] = feed_df['res_tag'].apply(lambda x: x.split() if isinstance(x, str) else x)

    
    # 각 태그마다 점수, 카테고리, 우선 순위 정보를 담은 딕셔너리 생성
    top10_tags_dict = {row['res_tag']: (row['score'], row['res_category'], i+1) for i, row in top10_tags.iterrows()}

    # 가장 높은 점수를 가진 태그와 그 태그의 카테고리 추출
    top_score = top10_tags['score'].iloc[0] if not top10_tags.empty else None
    top_tags = top10_tags[top10_tags['score'] == top_score]['res_tag'].tolist() if top_score else []
    top_tag_category = top10_tags.iloc[0]['res_category'] if not top10_tags.empty else None

    # 상위 태그 및 카테고리 확인용 출력
    print(f"top_tags: {top_tags}")
    print(f"top_category: {top_tag_category}")

    # 피드 데이터프레임 복사
    feeds = feed_df.copy()

    # 각 피드에 대해 추천 점수, 일치한 태그 수, 우선순위 계산
    feeds[['recommend_score', 'matched_tags', 'priority']] = feeds.apply(
    lambda row: recommend_score_and_priority(row, top10_tags_dict, top_tags, top_tag_category),
    axis=1
)

    # 우선순위(priority)에 따라 가중치를 부여할 맵 정의
    weights_map = {1: 2, 2: 1.5, 3: 1.2, 4: 1, 5: 0.8, 6: 0.7, 7: 0.5, 8: 0.4, 9: 0.3, 10: 0.1}
    feeds['weight'] = feeds['priority'].apply(lambda p: weights_map.get(p, 0.05))

    """
    # 0점 피드 제외
    # 추천 불가능한 피드(priority == 999) 제거
    feeds = feeds[feeds['priority'] != 999]
    print(f"priority 필터링 후 피드 개수: {len(feeds)}")

    # 필터링 후 피드가 없으면 빈 리스트 반환
    if feeds.empty:
        print("추천할 피드 없음. 빈 리스트 반환")
        return []
    """

    # 가중치를 기반으로 확률 분포 생성
    probs = feeds['weight'] / feeds['weight'].sum()

    # 확률에 따라 최대 20개의 피드를 랜덤 샘플링
    recommended_feeds = feeds.sample(n=min(20, len(feeds)), weights=probs, replace=False)

    print(f"추천된 피드 개수: {len(recommended_feeds)}")
    print("recommend_feed 함수 종료")

    return recommended_feeds.sort_values('recommend_score', ascending=False)['feed_idx'].tolist()
