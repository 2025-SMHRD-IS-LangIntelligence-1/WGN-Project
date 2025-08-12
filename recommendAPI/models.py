from pydantic import BaseModel # pydantic : 데이터 검증과 설정 관리를 위한 Python 라이브러리
from typing import List

# ------------------ 데이터 모델 정의 ------------------

# BaseModel을 활용하면 잘못된 데이터가 들어왔을 때 자동으로 422 에러를 띄워줌 (데이터 검증)

class WordcloudAndRatings(BaseModel):
    nk_positive_wc: str
    nk_negative_wc: str
    wgn_positive_wc: str
    wgn_negative_wc: str
    wgn_ratings: str

class Log(BaseModel):
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