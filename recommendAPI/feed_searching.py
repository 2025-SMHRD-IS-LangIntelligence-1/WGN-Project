from typing import List, Dict
import pandas as pd

def search_feed(feeds: List[Dict]) -> List[int]:

    print("=== search_feed 함수 실행 ===")
    
    # 스프링에서 넘어온 검색 후보 피드 정보를 데이터프레임화
    feed_df = pd.DataFrame(feeds)

    print("받은 피드 정보 : ", feed_df)

    result = [1, 2, 3]
    
    return result # 여기에 추천 피드 idx를 담아주기