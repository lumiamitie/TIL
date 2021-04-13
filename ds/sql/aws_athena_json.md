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

# escape 처리된 JSON String에서 데이터 추출하기

- 다음과 같이 따옴표 등 escape 처리가 되어있으면 `JSON_EXTRACT` 를 바로 사용할 수 없다.
- 이 경우에는 escape 문자열을 제거한 뒤에 JSON을 파싱하면 된다.
- 아래 쿼리에서는 `REGEXP_REPLACE` 를 사용한다.

```sql
WITH
sample_tbl AS (SELECT '{\"browser\":\"Chrome\",\"screen\":[1920,1080]}' AS json)
SELECT JSON_EXTRACT_SCALAR(REGEXP_REPLACE(json, '\\', ''), '$.browser') AS b,
       JSON_EXTRACT(REGEXP_REPLACE(json, '\\', ''), '$.screen') AS c
FROM sample_tbl

// b       c
// Chrome	 [1920,1080]
```

- 해당 로직이 반복적으로 사용되는 경우, WITH 문 내에서 처리하는 것도 좋다.

```sql
WITH
sample_tbl AS (
    SELECT REGEXP_REPLACE('{\"browser\":\"Chrome\",\"screen\":[1920,1080]}', '\\', '') AS json
)
SELECT JSON_EXTRACT_SCALAR(json, '$.browser') AS b,
       JSON_EXTRACT(json, '$.screen') AS c
FROM sample_tbl
```
