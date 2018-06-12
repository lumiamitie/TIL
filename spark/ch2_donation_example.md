# Ch2. 스칼라와 스파크를 활용한 데이터 분석

Spark 작업을 하둡 클러스터에서 실행한다.

```
spark-shell --master yarn --deploy-mode client
```

레코드 링크 데이터로 DataFrame을 생성한다

```
val prev = spark.read.csv("/user/miika/linkage")
```

위 데이터를 보다보니 다음과 같은 요구사항이 생겼다
- 첫 번째 row는 바로 header로 인식하면 좋겠다
- "?" 문자열이 들어간 경우 누락된 데이터로 처리한다
- 각 열의 데이터 타입을 유추한다

```
val parsed = spark.read.
  option("header", "true").
  option("nullValue", "?").
  option("inferSchema", "true").
  csv("/user/miika/linkage")
```

각 열의 유추된 데이터 타입을 확인해보자

```
parsed.printSchema()
// root
//  |-- id_1: integer (nullable = true)
//  |-- id_2: integer (nullable = true)
//  |-- cmp_fname_c1: double (nullable = true)
//  |-- cmp_fname_c2: double (nullable = true)
//  |-- cmp_lname_c1: double (nullable = true)
//  |-- cmp_lname_c2: double (nullable = true)
//  |-- cmp_sex: integer (nullable = true)
//  |-- cmp_bd: integer (nullable = true)
//  |-- cmp_bm: integer (nullable = true)
//  |-- cmp_by: integer (nullable = true)
//  |-- cmp_plz: integer (nullable = true)
//  |-- is_match: boolean (nullable = true)
```

DataFrame API를 통해 데이터를 집계해보자

```
parsed.
  groupBy("is_match").
  count().
  orderBy($"count".desc).
  show()
// +--------+-------+
// |is_match|  count|
// +--------+-------+
// |   false|5728201|
// |    true|  20931|
// +--------+-------+
```

데이터에서 열의 이름을 참조할 수 있는 방법은 두 가지가 있다

- 리터럴 문자열 사용 ( `groupBy("is_match")` )
- `$<"col">` 구문 사용 ( `orderBy($"count".desc)` )
- 대부분의 경우 어느쪽이든 사용할 수 있지만, count열에서 desc라는 이름의 메서드를 호출하기 위해서는 `$` 구문을 사용해야 한다


DataFrame API의 기능은 SQL 쿼리의 구성요소와 비슷하다. 우리가 생성한 모든 데이터 프레임을 데이터베이스 테이블처럼 다루면서 SQL을 통해 질의할 수도 있다.

먼저 Spark SQL 실행 엔진을 데이터프레임과 연결하는 이름을 지정한다

```
parsed.createOrReplaceTempView("linkage")
```

이제 parsed 데이터프레임을 스파크의 REPL 세션이 유지되는 동안 사용할 수 있게 되었다. 스파크를 Hive 메타스토어와 연결하도록 구성하면 HDFS에 저장된 테이블에 질의할 수도 있다.

임시 테이블을 Spark SQL 엔진에 등록했으니 다음과 같이 쿼리를 보낼 수 있다

```
spark.sql("""
    SELECT is_match, COUNT(*) AS cnt
    FROM linkage
    GROUP BY is_match
    ORDER BY cnt DESC
""").show()
```

Spark SQL과 DataFrame API는 각각 장단점이 있다

- Spark SQL
    - (+) 일반적으로 익숙한 구문이다
    - (+) 간단한 질의를 할 때는 훨씬 표현력이 좋다
    - (+) 많이 사용하는 열 중심형 파일 형식에 저장된 데이터를 빠르게 읽고 필터링하기 좋다
    - (-) 복잡하고 여러 단계로 이루어진 분석의 경우 표현하기 어렵다
- DataFrame API
    - (+) 복잡하고 여러 단계로 이루어진 분석을 표현하기 좋다

