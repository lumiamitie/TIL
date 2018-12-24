# Hive 에서 json 처리하기

다음 [문서](https://docs.microsoft.com/ko-kr/azure/hdinsight/hadoop/using-json-in-hive) 에서 필요한 부분만 정리

다음과 같은 json string이 Hive Table로 존재한다고 생각해보자. 여기서 값을 어떻게 추출할 수 있을까?

```json
{
  "StudentId": "trgfg-5454-fdfdg-4346",
  "Grade": 7,
  "StudentDetails": [
    {
      "FirstName": "Peggy",
      "LastName": "Williams",
      "YearJoined": 2012
    }
  ]
}
```

## 1) get_json_object

```sql
SELECT
  GET_JSON_OBJECT(tb_students.json_body, '$.StudentDetails.FirstName') AS first_name,
  GET_JSON_OBJECT(tb_students.json_body, '$.StudentDetails.LastName') AS last_name
FROM tb_students
;

--   _c0       _c1
-- Peggy  Williams
```

## 2) json_tuple

`json_tuple` 은 LATERAL VIEW를 통해 json을 처리한다

```sql
SELECT q1.StudentId, q1.Grade
FROM tb_students tt
LATERAL VIEW JSON_TUPLE(tt.json_body, 'StudentId', 'Grade') q1
  AS StudentId, Grade
;

--             StudentId  Grade
-- trgfg-5454-fdfdg-4346      7
```
