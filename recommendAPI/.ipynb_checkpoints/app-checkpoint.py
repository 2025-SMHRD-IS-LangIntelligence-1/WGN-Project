from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
from fastapi.responses import JSONResponse
import pandas as pd
import ast

# ------------------ 데이터 모델 정의 ------------------
class Log(BaseModel):
    log_idx: int
    mb_id: str
    res_idx: int
    res_category: str
    res_tag: str
    action_type: str
    created_at: str

class Feed(BaseModel):
    feed_idx: int
    res_idx: int
    feed_likes: int
    res_category: str
    res_tag: str

class RequestData(BaseModel):
    logs: List[Log]
    feeds: List[Feed]

# ------------------ FastAPI 앱 객체 ------------------
app = FastAPI()

# ------------------ API 엔드포인트 ------------------
@app.post("/receive_logs_and_feeds")
def receive_logs_and_feeds(data: RequestData):
    log_dicts = [log.dict() for log in data.logs]
    feed_dicts = [feed.dict() for feed in data.feeds]

    # 추천 피드 계산
    recommended_feed_ids = recommend_feed(log_dicts, feed_dicts)

    return JSONResponse(content={
        "message": f"{data.logs[0].mb_id}님 로그 {len(data.logs)}건, 피드 {len(data.feeds)}건 잘 받았습니다.",
        "recommended_feed_ids": recommended_feed_ids
    }, media_type="application/json; charset=utf-8")

# ------------------ 유틸 함수 ------------------
def safe_literal_eval(x):
    if isinstance(x, str):
        try:
            return ast.literal_eval(x)
        except Exception:
            return [x.strip()]
    return x

# ------------------ 추천 알고리즘 ------------------
def recommend_score_and_priority(row, user_tag_info, top_tags, top_tag_category):
    score = 0.0
    matched_tags = []
    best_priority = float('inf')

    for tag in row['res_tag']:
        if tag in user_tag_info:
            tag_score, tag_cat, tag_rank = user_tag_info[tag]
            matched_tags.append(tag)
            score += tag_score
            if tag_cat == row['res_category']:
                score += 0.2 * tag_score
            if tag_rank < best_priority:
                best_priority = tag_rank

    score += row['feed_likes'] * 0.03

    if any(tag in top_tags for tag in row['res_tag']):
        score += 5
    if best_priority == 1 and row['res_category'] == top_tag_category:
        score += 1

    if best_priority == float('inf'):
        best_priority = 999

    return pd.Series([score, matched_tags, best_priority])

def recommend_feed(log_dicts: List[dict], feed_dicts: List[dict]) -> List[int]:
    log_df = pd.DataFrame(log_dicts)
    feed_df = pd.DataFrame(feed_dicts)

    log_df['res_tag'] = log_df['res_tag'].apply(safe_literal_eval)
    feed_df['res_tag'] = feed_df['res_tag'].apply(safe_literal_eval)

    weights = {"글작성": 2, "찜": 1.5, "검색": 1.5, "좋아요": 1, "클릭": 1}
    log_df['score'] = log_df['action_type'].map(weights).fillna(0)

    df_exploded = log_df.explode('res_tag')

    user_tag_score = (
        df_exploded.groupby(['mb_id', 'res_tag', 'res_category'])['score']
        .sum().reset_index()
    )

    target_user = log_df['mb_id'].iloc[0]
    user_pref = user_tag_score[user_tag_score['mb_id'] == target_user] \
        .sort_values('score', ascending=False).reset_index(drop=True)

    user_tag_info = {
        row['res_tag']: (row['score'], row['res_category'], idx + 1)
        for idx, row in user_pref.iterrows()
    }
    top_score = user_pref['score'].iloc[0] if not user_pref.empty else None
    top_tags = user_pref[user_pref['score'] == top_score]['res_tag'].tolist() if top_score else []
    top_category = user_pref.iloc[0]['res_category'] if not user_pref.empty else None

    feeds = feed_df.copy()
    feeds[['recommend_score', 'matched_tags', 'priority']] = feeds.apply(
        lambda row: recommend_score_and_priority(row, user_tag_info, top_tags, top_category), axis=1
    )

    weights_map = {1: 2, 2: 1.5, 3: 1.2, 4: 1, 5: 0.8, 6: 0.7, 7: 0.5, 8: 0.4, 9: 0.3, 10: 0.1}
    feeds['weight'] = feeds['priority'].apply(lambda p: weights_map.get(p, 0.05))

    feeds = feeds[feeds['priority'] != 999]
    if feeds.empty:
        return []

    probs = feeds['weight'] / feeds['weight'].sum()
    recommended_feeds = feeds.sample(n=min(20, len(feeds)), weights=probs, replace=False)

    # feed_idx만 추출하여 반환
    return recommended_feeds.sort_values('recommend_score', ascending=False)['feed_idx'].tolist()
