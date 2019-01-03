# json 포맷의 문자열 직접 파싱하기

## 문제상황

* STRING 포맷의 컬럼에 json 데이터가 들어있다고 생각해보자
* json 으로 되어 있는 데이터에서 원하는 값만 추출하려면 어떻게 해야 할까?
* 하이브 단에서 처리할 수도 있다
    * `SparkSession.sql` 을 통해 Hive 쿼리를 날릴 때 json 데이터를 처리할 수 있는 함수를 적용하면 된다
    * 따라서 `get_json_object` 또는 json_tuple 을 통해 스파크로 데이터를 가져오기 전에 처리할 수 있다
* 스파크에서는 어떻게 할 수 있을까?

## 해결방법

* 다음 문서를 참고하여 진행
    * [Interactively analyse 100GB of JSON data with Spark](https://towardsdatascience.com/interactively-analyse-100gb-of-json-data-with-spark-e018f9436e76)
* `tb_data` 테이블에 있는 `log_data` 컬럼에 (STRING 타입) json 포맷으로 데이터가 들어가 있다고 생각해보자

```python
import json
from pyspark.sql.types import Row

raw_data = sc.sql('SELECT * FROM db.tb_data')

# json.loads 함수를 모든 Row에 적용하여 파싱한다
json_data = raw_data.select('log_data').rdd.map(lambda r: json.loads(r.log_data))

# 제대로 파싱되었는지 확인해보자
json_data.take(10)

# 어떤 key 값들이 존재하는지 확인해보자 (파이썬 list 형태로 반환된다)
click_keys = json_data.flatMap(lambda r: r.keys()).distinct().collect()
# [u'rawMessage', ... ]

(json_data
  .filter(lambda r: r['rawMessage'] is not None)
  # 비어있는 항목들이 가끔 존재하는데, 이런 경우 keyError가 발생한다.
  # 안전하게 값을 추출하기 위해 .get 메서드를 반복적으로 호출한다
  .map(lambda r: (r.get('rawMessage', {}).get('col1', {}).get('value1', None),
                  r.get('rawMessage', {}).get('col2', {}).get('value2', None) ))
  # 여기까지 해서 .take로 가져오면 그냥 파이썬 리스트 객체가 된다
  # .toDF 메서드를 통해 다시 DataFrame으로 돌린다
  .toDF()
  .take(5)
)

# [Row(_1=u'628aa364a2b94164a9a23be4143402cd', _2=u'5ab37084-60a2-4ef4-908c-da82bd6ffe9e'),
#  Row(_1=u'043b60331a6d4315aea63ff7d2ce9941', _2=u'0E57B958-D4C5-474E-A2F8-FE12C720F84A'),
#  Row(_1=u'47694f6f4f4445ebab56be15cf429cdc', _2=u'769f6f20-189d-40ad-9e4f-bf5aeb42cec1'),
#  Row(_1=u'248516016b9643ffafd5aac57f4d91d0', _2=u'c0b3af8e-d24f-4802-b1c1-eaa79205085b'),
#  Row(_1=u'b039c4b0d2bc11e79ff7000af759d1a0', _2=None)]
```

스파크 rdd로부터 DataFrame을 만드는 방법은 다음 [링크](https://stackoverflow.com/questions/39699107/spark-rdd-to-dataframe-python)를 참고

```python
click_id_extracted = (click_json
  # rawMessage가 존재하는 Row로만 필터링
  .filter(lambda r: r['rawMessage'] is not None)
  # json으로 추출한 값을 통해 Row를 구성
  .map(lambda r: Row(
          col1=r.get('rawMessage', {}).get('col1', {}).get('value1', None),
          col2=r.get('rawMessage', {}).get('col2', {}).get('value2', None)
  ))
  # 다시 DataFrame을 구성한다
  .toDF()
)

# [Row(col1=u'628aa364a2b94164a9a23be4143402cd', col2=u'5ab37084-60a2-4ef4-908c-da82bd6ffe9e'),
#  Row(col1=u'043b60331a6d4315aea63ff7d2ce9941', col2=u'0E57B958-D4C5-474E-A2F8-FE12C720F84A'),
#  Row(col1=u'47694f6f4f4445ebab56be15cf429cdc', col2=u'769f6f20-189d-40ad-9e4f-bf5aeb42cec1'),
#  Row(col1=u'248516016b9643ffafd5aac57f4d91d0', col2=u'c0b3af8e-d24f-4802-b1c1-eaa79205085b'),
#  Row(col1=u'b039c4b0d2bc11e79ff7000af759d1a0', col2=None)]
```
