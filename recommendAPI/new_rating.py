import pandas as pd
import numpy as np
import ast
import re
import pymysql

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