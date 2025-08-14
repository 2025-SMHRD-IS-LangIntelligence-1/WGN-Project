# reco_engine.py
from typing import List
import pandas as pd
import numpy as np
import re
import pymysql
from collections import Counter
import time

# =========================
# DB 유틸
# =========================
def db_connect(query: str, columns: list[str]) -> pd.DataFrame:
    conn = pymysql.connect(
        host='project-db-cgi.smhrd.com',
        port=3307,
        user='CGI_25IS_LI_P2_3',
        password='smhrd3',
        db='CGI_25IS_LI_P2_3',
        charset='utf8mb4'
    )
    try:
        with conn.cursor() as cursor:
            cursor.execute(query)
            rows = cursor.fetchall()
            df = pd.DataFrame(rows, columns=columns)
    finally:
        conn.close()
    return df

def get_conn():
    return pymysql.connect(
        host='project-db-cgi.smhrd.com', port=3307,
        user='CGI_25IS_LI_P2_3', password='smhrd3',
        db='CGI_25IS_LI_P2_3', charset='utf8mb4', autocommit=True
    )

# =========================
# 사후 DB 반영 (추천 후에만 실행)
# =========================
def persist_recommendation_after(
    mb_id: str,
    feed_ids: List[int],
    cleanup_hours: int = 1,
    cleanup_limit: int = 5000,
    cleanup_prob: float = 0.10
) -> int:
    """
    추천이 끝난 뒤 호출. 한 커넥션에서
    - INSERT IGNORE (멀티 VALUES)
    - 확률적으로 배치 삭제(LIMIT)
    를 처리.
    인덱스 권장:
      ALTER TABLE t_feed_recommend
        ADD UNIQUE KEY ux_feedrec_mb_feed (mb_id, feed_idx),
        ADD KEY idx_feedrec_time (recommended_at);
    """
    inserted = 0
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            if feed_ids:
                values = ",".join(["(%s, %s, NOW())"] * len(feed_ids))
                sql_ins = f"""
                    INSERT IGNORE INTO t_feed_recommend (mb_id, feed_idx, recommended_at)
                    VALUES {values}
                """
                params = []
                for fid in feed_ids:
                    params += [mb_id, int(fid)]
                cur.execute(sql_ins, params)
                inserted = cur.rowcount

            # 확률적으로 오래된 기록 배치 청소
            import random
            if random.random() < cleanup_prob:
                sql_del = """
                    DELETE FROM t_feed_recommend
                    WHERE recommended_at < (NOW() - INTERVAL %s HOUR)
                    LIMIT %s
                """
                cur.execute(sql_del, (int(cleanup_hours), int(cleanup_limit)))
    finally:
        conn.close()
    return inserted

# =========================
# 빠른 토크나이저 & 점수 유틸
# =========================
_WORD_RE = re.compile(r"[0-9a-z가-힣]+")

def _word_list_ko_fast(s: str) -> list[str]:
    if not isinstance(s, str) or not s:
        return []
    s = s.lower().replace("별루", "별로")
    s = re.sub(r"[^0-9a-z가-힣\s]", " ", s)
    return _WORD_RE.findall(s)

def build_top10_dict(exploded_df: pd.DataFrame):
    """
    exploded_df: ['res_tag','res_category','score']
    return:
      top10_dict: tag -> (raw_score, category, rank, normalized_weight)
      top_tags: 최고점과 동점 태그 리스트
      top_tag_category: 최상위 태그의 카테고리
      max_score: 상위태그 중 최대 score
    """
    if exploded_df.empty:
        return {}, [], None, 0.0
    top10 = (exploded_df.groupby(['res_tag','res_category'])['score']
             .sum().reset_index()
             .sort_values('score', ascending=False).head(10))
    max_score = float(top10['score'].max())
    top10_dict = {}
    for _, row in top10.iterrows():
        tag = row['res_tag']; cat = row['res_category']; s = float(row['score'])
        rank = len(top10_dict) + 1
        top10_dict[tag] = (s, cat, rank, (s/max_score if max_score>0 else 0.0))
    top_score = top10['score'].iloc[0]
    top_tags = top10.loc[top10['score']==top_score, 'res_tag'].tolist()
    top_tag_category = top10.iloc[0]['res_category']
    return top10_dict, top_tags, top_tag_category, max_score

# =========================
# 추천 메인 (ULTRA: k×n 완전 벡터화) — 부작용 없음
# =========================
def recommend_feed_ultra_no_sideeffects(
    mb_id: str,
    log_df: pd.DataFrame,
    feed_df: pd.DataFrame,
    follow_df: pd.DataFrame | None = None,
    recent_rec_df: pd.DataFrame | None = None,
    max_count: int = 20,
    tag_hit_boost: float = 3.0,
    max_hit_per_tag: int = 2,
) -> List[int]:
    t0 = time.perf_counter()
    if follow_df is None:
        follow_df = pd.DataFrame(columns=['following_id'])

    # 0) 최근 추천 제외
    feeds = feed_df.copy()
    if recent_rec_df is not None and not recent_rec_df.empty:
        exclude = set(recent_rec_df['feed_idx'].astype(int))
        if exclude:
            feeds = feeds[~feeds['feed_idx'].astype(int).isin(exclude)]
    if feeds.empty:
        return []

    # 1) 로그 → Top10
    log_df2 = log_df.drop(columns=['mb_id'], errors='ignore').copy()
    log_df2['res_tag'] = log_df2['res_tag'].apply(lambda x: x.split() if isinstance(x, str) else [])
    weights = {"글작성": 2, "찜": 1.5, "검색": 1.5, "좋아요": 1, "클릭": 1}
    log_df2['score'] = log_df2['action_type'].map(weights).fillna(0.0)
    expl = log_df2.explode('res_tag')
    top10_dict, top_tags, top_tag_cat, max_tag_score = build_top10_dict(expl)

    # 2) 피드 전처리
    feeds = feeds.copy()
    feeds['res_tag'] = feeds['res_tag'].apply(lambda x: x.split() if isinstance(x, str) else [])
    feeds['created_at'] = pd.to_datetime(feeds['created_at'], errors='coerce')

    n = len(feeds)
    res_cat_arr  = feeds['res_category'].tolist()
    res_tags_arr = [set(tags) if isinstance(tags, list) else set() for tags in feeds['res_tag'].tolist()]
    likes_arr    = feeds['feed_likes'].fillna(0).astype(float).to_numpy()

    # 본문 Counter 1회 계산
    content_counters = [
        Counter(_word_list_ko_fast(c)) if isinstance(c, str) and c else {}
        for c in feeds['feed_content'].tolist()
    ]

    # ===== k×n 벡터화 =====
    tags_k = list(top10_dict.keys())
    k = len(tags_k)
    tag_score_k = np.array([top10_dict[t][0] for t in tags_k], dtype=float)
    tag_cat_k   = [top10_dict[t][1] for t in tags_k]
    tag_rank_k  = np.array([top10_dict[t][2] for t in tags_k], dtype=int)
    tag_norm_k  = np.array([top10_dict[t][3] for t in tags_k], dtype=float)

    has_tag_kxn = np.empty((k, n), dtype=bool) if k > 0 else np.zeros((0, n), dtype=bool)
    for i, t in enumerate(tags_k):
        has_tag_kxn[i] = np.fromiter((t in s for s in res_tags_arr), dtype=bool, count=n)

    rec_scores = np.zeros(n, dtype=float)
    priority   = np.full(n, 999, dtype=int)

    if k > 0:
        # 기본 태그 점수
        rec_scores += (has_tag_kxn * tag_score_k[:, None]).sum(axis=0)

        # 카테고리 보너스
        same_cat_kxn = np.empty((k, n), dtype=bool)
        for i, cat in enumerate(tag_cat_k):
            same_cat_kxn[i] = np.fromiter((rc == cat for rc in res_cat_arr), dtype=bool, count=n)
        rec_scores += ((has_tag_kxn & same_cat_kxn) * (0.2 * tag_score_k[:, None])).sum(axis=0)

        # priority = 최소 rank
        for i in range(k):
            mask = has_tag_kxn[i]
            if mask.any():
                np.minimum(priority, tag_rank_k[i], out=priority, where=mask)

    # 최상위 태그 보너스
    if k > 0 and top_tags:
        idxs = [tags_k.index(t) for t in top_tags if t in top10_dict]
        if idxs:
            has_top = has_tag_kxn[idxs].any(axis=0)
            rec_scores += has_top.astype(float) * 5.0

    # rank==1 + 카테일치 보너스
    if k > 0 and top_tag_cat:
        rec_scores += np.where((priority == 1) & (np.array(res_cat_arr, dtype=object) == top_tag_cat), 1.0, 0.0)

    # 좋아요 보너스
    rec_scores += likes_arr * 0.03

    # 본문 부스트 (k×n)
    if max_tag_score > 0 and k > 0:
        for i, t in enumerate(tags_k):
            cnt_i = np.fromiter((c.get(t, 0) for c in content_counters), dtype=int, count=n)
            rec_scores += tag_norm_k[i] * tag_hit_boost * np.minimum(cnt_i, max_hit_per_tag)

    feeds['recommend_score'] = rec_scores
    feeds['priority'] = priority

    # 샘플링 가중치
    w = np.full(n, 0.05, dtype=float)
    for r, val in [(1,2),(2,1.5),(3,1.2),(4,1.0),(5,0.8),(6,0.7),(7,0.5),(8,0.4),(9,0.3),(10,0.1)]:
        w[priority == r] = val
    feeds['weight'] = w

    # 팔로우 + 24시간 우선
    following_ids = set(follow_df['following_id'].astype(str)) if follow_df is not None and not follow_df.empty else set()
    recent_cutoff = pd.Timestamp.now() - pd.Timedelta(days=1)
    mask_recent_follow = (
        feeds['mb_id'].astype(str).isin(following_ids)
        & feeds['created_at'].notna()
        & (feeds['created_at'] >= recent_cutoff)
    )
    recent_follow_feeds = feeds[mask_recent_follow].sort_values(
        by=['created_at','recommend_score'], ascending=[False, False]
    )

    # 나머지 가중 샘플링
    others = feeds[~mask_recent_follow]
    remain_n = max_count - len(recent_follow_feeds)
    if remain_n > 0 and not others.empty:
        probs = others['weight'].to_numpy()
        tot = probs.sum()
        probs = (probs/tot) if tot > 0 else None
        sampled = others.sample(n=min(remain_n, len(others)), weights=probs, replace=False)
    else:
        sampled = others.iloc[0:0]

    out = pd.concat([recent_follow_feeds, sampled], ignore_index=True)
    out = out.drop_duplicates(subset='feed_idx', keep='first')

    # 폴백: 그래도 비면 최신/좋아요순
    if out.empty:
        out = feeds.sort_values(by=['created_at','feed_likes'], ascending=[False, False]).head(max_count)

    result_ids = out.sort_values('recommend_score', ascending=False)['feed_idx'].astype(int).tolist()

    t1 = time.perf_counter()
    print(f"[추천-ULTRA(no side effects)] feeds:{len(feeds)} / {(t1-t0)*1000:.1f} ms")
    return result_ids

# =========================
# 공개 API: 사용자별 추천 + (사후) DB 반영
# =========================
def get_recommendations_for_user(user_id: str, max_count: int = 20) -> List[int]:
    """
    1) 필요한 데이터 로드
    2) 빠른 추천 계산(부작용 없음)
    3) (사후) 추천 결과를 DB에 기록 + 확률적 청소
    4) feed_idx 리스트 반환
    """
    # 1) 사용자 로그
    query1 = f"""
        SELECT l.log_idx, l.mb_id, r.res_idx, r.res_category,
               r.res_tag, l.action_type, l.created_at
        FROM t_log l
        LEFT JOIN t_restaurant r ON r.res_idx = l.res_idx
        WHERE l.mb_id = "{user_id}"
        ORDER BY l.created_at DESC
        LIMIT 500
    """
    columns1 = ['log_idx', 'mb_id', 'res_idx', 'res_category', 'res_tag', 'action_type', 'created_at']
    log_df = db_connect(query1, columns1)

    # 2) 팔로우 목록
    query2 = f"""
        SELECT following_id
        FROM t_follow
        WHERE follower_id = "{user_id}"
    """
    columns2 = ['following_id']
    follow_df = db_connect(query2, columns2)

    # 3) 피드 후보 (최근 30일 + 자기 자신 제외 + 최근 1시간 이미 추천 제외)
    query3 = f"""
        SELECT
            f.feed_idx,
            r.res_idx,
            f.mb_id,
            f.feed_content,
            f.feed_likes,
            f.created_at,
            r.res_category,
            r.res_tag
        FROM t_feed f
        LEFT JOIN t_restaurant r ON r.res_idx = f.res_idx
        WHERE f.mb_id != "{user_id}"
          AND f.created_at >= NOW() - INTERVAL 30 DAY
          AND NOT EXISTS (
            SELECT 1 FROM t_feed_recommend tr
            WHERE tr.mb_id = "{user_id}"
              AND tr.feed_idx = f.feed_idx
              AND tr.recommended_at >= NOW() - INTERVAL 1 HOUR
          )
        ORDER BY f.created_at DESC
        LIMIT 1000
    """
    columns3 = ['feed_idx', 'res_idx', 'mb_id','feed_content','feed_likes','created_at','res_category','res_tag']
    feed_df = db_connect(query3, columns3)

    # 4) (옵션) 파이썬에서도 최근추천 재확인
    query4 = f"""
        SELECT mb_id, feed_idx
        FROM t_feed_recommend
        WHERE mb_id = "{user_id}"
          AND recommended_at >= NOW() - INTERVAL 1 HOUR
    """
    columns4 = ['mb_id','feed_idx']
    recent_rec_df = db_connect(query4, columns4)

    # 5) 추천 계산 (부작용 없음)
    rec_ids = recommend_feed_ultra_no_sideeffects(
        mb_id=user_id,
        log_df=log_df,
        feed_df=feed_df,
        follow_df=follow_df,
        recent_rec_df=recent_rec_df,
        max_count=max_count,
        tag_hit_boost=3.0,
        max_hit_per_tag=2,
    )

    # 6) 사후 DB 반영 (멀티 VALUES + 배치 청소)
    if rec_ids:
        persist_recommendation_after(
            mb_id=user_id,
            feed_ids=rec_ids,
            cleanup_hours=1,
            cleanup_limit=5000,
            cleanup_prob=0.10
        )

    return rec_ids
