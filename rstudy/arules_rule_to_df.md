# arules 결과물을 tibble 데이터프레임으로 변환하기

`arules` 라이브러리의 주요 결과물은 `rules` 클래스 또는 `itemsets` 클래스다. rule을 추출하거나 라이브러리에서 주어진 시각화 함수를 사용할 때는 해당 클래스를 그대로 사용하는 것이 편리하다. 하지만 표로 정리하거나 다른 라이브러리에 맞게 데이터를 변환해야 하는 경우, 일반 데이터프레임이나 tibble 형태로 변경해야 하는 경우가 종종 있다.

따라서 다음과 같이 `as_df` 라는 제네릭 함수를 만들고, `rules` 또는 `itemsets` 클래스에 해당하는 값을 받아서 `data_frame` 으로 반환하는 함수를 작성하였다.

```r
as_df = function(x, ...) { UseMethod('as_df') }

as_df.rules = function(target_rule, delim = ', ', as_list = FALSE) {
  if (as_list) {
    vec_lhs = arules::LIST(arules::lhs(target_rule))
    vec_rhs = arules::LIST(arules::rhs(target_rule))
  } else {
    vec_lhs = map_chr(arules::LIST(arules::lhs(target_rule)), ~ paste(.x, collapse = delim))
    vec_rhs = map_chr(arules::LIST(arules::rhs(target_rule)), ~ paste(.x, collapse = delim))
  }
  
  df_quality = tbl_df(arules::quality(target_rule))
  
  data_frame(lhs = vec_lhs, rhs = vec_rhs) %>% bind_cols(df_quality)
}

as_df.itemsets = function(target_rule, delim = ', ', as_list = FALSE) {
  if (as_list) {
    vec_items = arules::LIST(arules::items(target_rule))
  } else {
    vec_items = map_chr(arules::LIST(arules::items(target_rule)), ~ paste(.x, collapse = delim))  
  }
  
  df_quality = tbl_df(arules::quality(target_rule))
  
  data_frame(items = vec_items) %>% bind_cols(df_quality)
}
```
