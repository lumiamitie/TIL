# Split 함수를 NSE(Non Standard Evaluation)로 구현해보자

원래 `base::split` 은 다음과 같이 사용한다

```r
split(mtcars, mtcars$cyl)
```

위 함수를 NSE로 바꾸어 구현해보자

```r
# split의 원래 구현은 다음과 같이 되어 있다.
# > split.data.frame
# function (x, f, drop = FALSE, ...)
#   lapply(split(x = seq_len(nrow(x)), f = f, drop = drop, ...),
#          function(ind) x[ind, , drop = FALSE])

split_nse = function(df, col) {
  col_captured = substitute(col)
  col_evaled = eval(col_captured, df, parent.frame())

  idx = split(x = seq_along(col_evaled), f = col_evaled, drop = FALSE)
  lapply(idx, function(x) df[x, , drop = FALSE])
}

split_nse(mtcars, cyl)
```
