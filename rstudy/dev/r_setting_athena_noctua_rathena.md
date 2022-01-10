
TODO : noctua와 RAthena를 통해 AWS Athena 사용하는 방법을 정리한다.

- noctua (R paws SDK 사용) : https://github.com/DyfanJones/noctua
- RAthena (Python Boto3 SDK 사용) : https://github.com/DyfanJones/RAthena

# noctua

```r
library(dplyr)
library(dbplyr)

con <- DBI::dbConnect(
  noctua::athena(),
  aws_access_key_id='<ACCESS_KEY_ID>',
  aws_secret_access_key='<SECRET_ACCESS_KEY>',
  s3_staging_dir='s3://dtr-warehouse/athena-query-results/<user-id>/',
  region_name='<region_name>'
)

lazy_table <- tbl(con, in_schema('db_name', 'table_name'))
```
