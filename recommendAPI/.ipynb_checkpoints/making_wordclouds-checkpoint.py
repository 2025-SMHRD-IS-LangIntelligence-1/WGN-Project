from io import BytesIO  # 메모리 버퍼를 사용하기 위한 모듈
from wordcloud import WordCloud  # 워드클라우드 생성 라이브러리
from typing import List # 리스트 타이핑
import base64  # 바이너리 데이터를 base64 문자열로 인코딩하는 모듈
from models import Review, Wordcloud

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


def make_wordclouds(review_list: List[Review]) -> Wordcloud:

    print("=== make_wordclouds 함수 실행 ===")

    print("=== make_wordclouds 함수 종료 ===")    
    
    return 
        Wordcloud(
        NkPositiveWC=text_to_base64_wordcloud(), # 여기에 워드클라우드 이미지 문자열 넣을 것
        NkNegativeWC=text_to_base64_wordcloud(),
        WgnPositiveWC=text_to_base64_wordcloud(),
        WgnNegativeWC=text_to_base64_wordcloud(),
    )
