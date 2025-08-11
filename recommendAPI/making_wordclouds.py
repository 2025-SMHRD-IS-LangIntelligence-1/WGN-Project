# ========================== 리뷰 워드클라우드 알고리즘 ==========================

from io import BytesIO  # 메모리 버퍼를 사용하기 위한 모듈
from wordcloud import WordCloud  # 워드클라우드 생성 라이브러리
from typing import List # 리스트 타이핑
import base64  # 바이너리 데이터를 base64 문자열로 인코딩하는 모듈
from models import WordcloudAndRatings

# DB 연결 함수
def db_connect(query, columns) :
    print("DB 연결 중...")
    
    # DB 연결 설정
    conn = pymysql.connect(
    host='project-db-cgi.smhrd.com',
    port=3307,
    user='CGI_25IS_LI_P2_3',
    password='smhrd3',
    db='CGI_25IS_LI_P2_3',
    charset='utf8mb4'
    )
    
    with conn.cursor() as cursor:
      cursor.execute(query)
      rows = cursor.fetchall()
      df = pd.DataFrame(rows, columns=columns)
      conn.close()

    print("DB 연결 완료!")

    return df
    
def text_to_base64_wordcloud(text: str) -> str:
    # 입력받은 텍스트로 워드클라우드 이미지를 생성하여
    # PNG 포맷으로 메모리 버퍼에 저장한 후
    # Base64 문자열로 변환해 반환하는 함수

    print("=== text_to_base64_wordcloud 함수 실행 ===")

    wc = WordCloud(
        width=400, height=400, background_color="white",
        font_path="malgun.ttf"  # 한글 폰트 경로
    )

    wc.generate(text)  # 워드클라우드 이미지 생성

    buffer = BytesIO()  # 메모리 버퍼 생성
    wc.to_image().save(buffer, format="PNG")  # 워드클라우드 이미지를 PNG로 버퍼에 저장

    img_str = base64.b64encode(buffer.getvalue()).decode()
    # 버퍼의 바이너리 데이터를 base64 문자열로 인코딩 후 디코딩하여 str로 변환

    print("=== text_to_base64_wordcloud 함수 종료 ===")

    return img_str  # Base64로 인코딩된 워드클라우드 이미지 문자열 반환

# =============================================================

def make_wordclouds(res_idx : int) -> Wordcloud:

    query = """
    SELECT
    r.res_idx,

    (
        SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
        FROM t_review tr
        WHERE tr.res_idx = r.res_idx
          AND tr.mb_id = 'naver12345'
    ) AS naver_reviews,

    (
        SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
        FROM t_review tr
        WHERE tr.res_idx = r.res_idx
          AND tr.mb_id = 'kakao12345'
    ) AS kakao_reviews,

    (
        SELECT GROUP_CONCAT(review_content SEPARATOR ' ')
        FROM t_review tr
        WHERE tr.res_idx = r.res_idx
          AND tr.mb_id NOT IN ('naver12345', 'kakao12345')
    ) AS wagunyam_review,

    (
        SELECT GROUP_CONCAT(feed_content SEPARATOR ' ')
        FROM t_feed tf
        WHERE tf.res_idx = r.res_idx
    ) AS wagunyam_feed

    FROM
        (
            SELECT DISTINCT res_idx FROM t_review
            UNION
            SELECT DISTINCT res_idx FROM t_feed
        ) r
    
    WHERE r.res_idx = #{res_idx};
    """

    columns = ['res_idx', 'naver_reviews', 'kakao_reviews', 'wgn_feed', 'wgn_review']

    df = db_connect(query, columns)
    
    print("=== make_wordclouds 함수 실행 ===")

    NkPositive_text = "여기에 네이버/카카오 긍정 리뷰 텍스트를 모두 합친 문자열 넣기"
    NkNegative_text = "여기에 네이버/카카오 부정 리뷰 텍스트를 모두 합친 문자열 넣기"
    WgnPositive_text = "여기에 와구냠 긍정 리뷰 텍스트를 모두 합친 문자열 넣기"
    WgnNegative_text = "여기에 와구냠 부정 리뷰 텍스트를 모두 합친 문자열 넣기"
    
    print("=== make_wordclouds 함수 종료 ===")

    return [nk_positive_wc=text_to_base64_wordcloud(NkPositive_text),
        nk_negative_wc=text_to_base64_wordcloud(NkNegative_text),
        wgn_positive_wc=text_to_base64_wordcloud(WgnPositive_text),
        wgn_negative_wc=text_to_base64_wordcloud(WgnNegative_text)]
