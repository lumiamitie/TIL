# PCA in Spark

다음과 같은 과정을 통해 Spark에서 PCA를 적용하였다.

1. Hive에서 쿼리를 통해 가져온 데이터를 wide 포맷으로 피벗한다
2. `VectorAssembler`를 사용하여 하나의 feature column으로 묶는다
3. PCA를 적용한다
4. 결과를 Hive Table로 export한다

```python
import pyspark
from pyspark.sql import *
from pyspark.ml.feature import PCA, VectorAssembler

# SparkContext는 변수 sc에 정의되어 있다
score_data = sc.sql(query)

score_wide = (score_data
 .groupby('id')
 .pivot('cate_id')
 .avg('score')
 .fillna(0)
)
 
# VectorAssembler를 적용하려는 대상 컬럼을 리스트로 추출한다
target_columns = [k for k in score_wide.schema.names if k != 'id']

# VectorAssembler를 적용한다
vecAssembler = VectorAssembler(
    inputCols=target_columns, 
    outputCol='features'
)
score_features = vecAssembler.transform(score_wide)

# pca를 학습한다
pca = PCA(k=2, inputCol='features', outputCol='pca_features')
model_pca = pca.fit(score_features)

# 결과를 추출한다
pca_result = (model_pca
    .transform(score_features)
    .select(['id', 'pca_features'])
)

# 결과값을 담기 위한 Hive 테이블을 생성한다
sc.sql("""
CREATE TABLE IF NOT EXISTS database.table (
  id STRING,
  pca_features struct<type:tinyint,size:int,indices:array<int>,values:array<double>>
)
""")

# 결과 업로드
pca_result.write.mode('overwrite').saveAsTable('database.table')
```
