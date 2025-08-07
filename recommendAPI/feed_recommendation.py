import ast # Abstract Syntax Trees : 문자열로 되어 있는 파이썬 표현식을 실제 파이썬 객체로 안전하게 변환 (eval 대신 사용 가능, 보안 중시)
import pandas as pd
import numpy as np
from typing import List

# ------------------ 피드 추천 알고리즘 ------------------
# 홈 화면에 뜨는 사용자 행동 로그 기반 추천 알고리즘
    
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
