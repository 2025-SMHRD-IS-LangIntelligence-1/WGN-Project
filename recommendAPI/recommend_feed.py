import pandas as pd
import ast

def r
# tags 문자열을 리스트로 변환
df['tags'] = df['tags'].apply(lambda x: ast.literal_eval(x) if isinstance(x, str) else x)

# 1. 행동별 가중치 맵
weights = {
    "피드 작성": 2,
    "리뷰 작성": 2,
    "찜": 1.5,
    "검색": 1.5,
    "좋아요": 1,
    "click": 1
}

# 2. 점수 계산
df['score'] = df['action'].map(weights).fillna(0)

# 3. tags explode (태그별로 행 분리)
df_exploded = df.explode('tags')

# 4. 유저 × 태그 × 카테고리 점수 합산
user_tag_score = (
    df_exploded.groupby(['user_id', 'tags', 'category'])['score']
    .sum()
    .reset_index()
)

# 5. 유저별 Top 10 태그 (카테고리 포함)
top10_tags = (
    user_tag_score
    .sort_values(['user_id', 'score'], ascending=[True, False])
    .groupby('user_id')
    .head(10)
)

# 출력
print("\n=== 유저별 Top 10 태그 (태그 + 카테고리) ===")
print(top10_tags)

# CSV 저장
top10_tags.to_csv("user_top10_tags_with_category_weighted.csv", index=False, encoding="utf-8-sig")

df1 = pd.read_csv('./data/feed_restaurant_data_500.csv')

user_tags = pd.read_csv("./user_top10_tags_with_category_weighted.csv")
user_tags

import pandas as pd
import ast
import numpy as np

# 1. 데이터 불러오기
feeds = pd.read_csv("./data/feed_restaurant_data_500.csv")
user_tags = pd.read_csv("./user_top10_tags_with_category_weighted.csv")

feeds['tags'] = feeds['tags'].apply(lambda x: ast.literal_eval(x) if isinstance(x, str) else x)
target_user = "user1"

# 유저 태그 선호도
user_tag_pref = user_tags[user_tags['user_id'] == target_user].sort_values('score', ascending=False).reset_index(drop=True)
user_tag_info = {row['tags']: (row['score'], row['category'], i+1) for i, row in user_tag_pref.iterrows()}

# top tags
top_score = user_tag_pref['score'].iloc[0] if not user_tag_pref.empty else None
top_tags = user_tag_pref[user_tag_pref['score'] == top_score]['tags'].tolist() if top_score else []
top_tag_category = user_tag_pref.iloc[0]['category'] if not user_tag_pref.empty else None

# 점수 + priority 계산
def recommend_score_and_priority(row):
    score = 0.0
    matched_tags = []
    best_priority = float('inf')

    for tag in row['tags']:
        if tag in user_tag_info:
            tag_score, tag_cat, tag_rank = user_tag_info[tag]
            matched_tags.append(tag)
            score += tag_score
            if tag_cat == row['category']:
                score += 0.2 * tag_score
            if tag_rank < best_priority:
                best_priority = tag_rank

    score += row['feed_likes'] * 0.03
    if any(tag in top_tags for tag in row['tags']):
        score += 5
    if best_priority == 1 and top_tag_category and row['category'] == top_tag_category:
        score += 1

    if best_priority == float('inf'):
        best_priority = 999

    return pd.Series([score, matched_tags, best_priority])

feeds[['recommend_score', 'matched_tags', 'priority']] = feeds.apply(recommend_score_and_priority, axis=1)

# ---- 가중치 기반 섞기 ----
# priority에 따라 weight 부여
weights_map = {1: 2, 2: 1.5, 3: 1.2, 4: 1, 5: 0.8, 6: 0.7, 7: 0.5, 8: 0.4, 9: 0.3, 10: 0.1}
feeds['weight'] = feeds['priority'].apply(lambda p: weights_map.get(p, 0.05))

# 0점 피드 제외
feeds = feeds[feeds['priority'] != 999]

# 확률 기반으로 20개 샘플링
probs = feeds['weight'] / feeds['weight'].sum()
recommended_feeds = feeds.sample(n=20, weights=probs, replace=False, random_state=None)

# 점수순으로 한 번 정렬(같은 priority 내)
recommended_feeds = recommended_feeds.sort_values('recommend_score', ascending=False)

# 추가 컬럼
recommended_feeds['user_top_tags'] = ", ".join(top_tags)
recommended_feeds['user_top_tag_category'] = top_tag_category

# 결과 출력'
print(recommended_feeds[['feed_id','restaurant_id','category','tags','matched_tags',
                         'priority','feed_likes','recommend_score',
                         'user_top_tags','user_top_tag_category']])

