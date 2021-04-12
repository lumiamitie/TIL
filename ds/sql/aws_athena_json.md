# JSON String 에서 데이터 추출하기

- JSON 포맷으로 되어있는 문자열에서 원하는 정보를 추출하기 위해서는 2가지 방법이 존재한다
    - `JSON_EXTRACT` → JSON 인코딩 문자열이 반환된다
    - `JSON_EXTRACT_SCALAR` → 스칼라 값만 반환된다(bool, number, character)
        - 배열, 맵, 구조체에는 `JSON_EXTRACT_SCALAR` 를 사용하면 안된다

```sql
WITH
sample_tbl AS (
    SELECT '{"browser":"Chrome","screen":[1920,1080]}' AS json
)
SELECT JSON_EXTRACT(json, '$.browser') AS a,
       JSON_EXTRACT_SCALAR(json, '$.browser') AS b,
       JSON_EXTRACT(json, '$.screen') AS c,
       JSON_EXTRACT_SCALAR(json, '$.screen') AS d
FROM sample_tbl
;

// a         b       c            d
// "Chrome"	 Chrome	 [1920,1080]
```

[JSON에서 데이터 추출](https://docs.aws.amazon.com/ko_kr/athena/latest/ug/extracting-data-from-JSON.html)
