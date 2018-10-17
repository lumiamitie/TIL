# Dataframe으로부터 transaction 구성하기

## Definition

`arules` 라이브러리를 사용할 때 `read.transaction()` 을 통해 텍스트 형태로 된 트랜잭션 파일을 불러올 수 있다. 파일 대신 데이터프레임의 형태로 사용할 수 있도록 함수를 재구성하였다. 해당 함수는 다음과 같은 형태로 동작한다.

1. id 값과 item 항목을 받아서 Factor로 구성한다
2. id와 item으로 구성된 sparse matrix를 생성한다
3. matrix를 transaction 형태로 변경한다

종종 다른 분석에 사용할 목적으로 matrix 결과물 자체가 필요한 경우가 있다. 이러한 경우를 구별하기 위해 `as` 파라미터를 추가하여 구분한다.

```r
trx_from_df = function(df, id, item, as = c('transaction', 'matrix')) {
  col_id = rlang::enquo(id)
  col_item = rlang::enquo(item)
  .as = match.arg(as, c('transaction', 'matrix'))
  
  .extract_as_factor = function(col) factor(rlang::eval_tidy(col, data = df))
  f_id = .extract_as_factor(col_id)
  f_item = .extract_as_factor(col_item)
  
  item_matrix = new(
    "ngTMatrix",
    i = as.integer(f_item) - 1L,
    j = as.integer(f_id) - 1L,
    Dim = c(length(levels(f_item)), length(levels(f_id))),
    Dimnames = list(levels(f_item), NULL)
  )
  
  if (.as == 'transaction') {
    trx = as(as(item_matrix, 'ngCMatrix'), 'transactions')
    arules::transactionInfo(trx) = data.frame(transactionID = levels(f_id))
    return(trx)
  } else if (.as == 'matrix') {
    return(as(item_matrix, 'ngCMatrix'))
  }
}
```

## Example

```r
sample_df = data.frame(id_index = 1:5, name = LETTERS[1:5])
#   id_index name
# 1        1    A
# 2        1    B
# 3        2    C
# 4        2    D
# 5        3    E
# ...

trx_from_df(sample_df, id_index, name)
```
