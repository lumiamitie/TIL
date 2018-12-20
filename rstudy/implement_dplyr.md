# dplyr을 직접 구현해보자!

## filter

실제 `filter` 함수의 내부 중요 로직은 C++로 작성되어 있다. [source](https://github.com/tidyverse/dplyr/blob/master/src/filter.cpp#L194)

filter 함수의 주요한 특징은 다음과 같다.

- `filter(data, 조건식1, 조건식2, ...)` 의 형태로 사용한다
- 여러 조건식들을 `,` 를 통해 연결할 경우 `&` 를 사용하는 것과 동일하게 처리한다

### 구현

이제 `filter` 함수를 직접 구현해보자. 실제로는 여러 함수들에 기능들이 나누어져 있지만,
전체적인 플로우를 살펴보기 위해 `custom_filter` 라는 함수를 정의하고 그 안에 필요한 기능들을 정의해보자.

```r
custom_filter = function(.data, ...) {
  # { ... } 필터링 조건들을 캡쳐한다
  dots = rlang::quos(...)

  if (length(dots) == 0) {
    # Filter 조건이 없을 때는 에러를 발생시킨다

    abort("At least one expression must be given")

  } else if (length(dots) == 1) {
    ## Filter 조건이 1개일 때는 그냥 옮겨둔다 ##

    quo_ = dots[[1]]

  } else {
    ## Filter 조건이 2개 이상일 때! ##

    # 리스트 형태로 주어진 조건 구문들을 하나로 묶는다
    # 여러개의 필터링 조건들을 주어진 연산자 (op, 여기서는 "&" 연산자) 로 묶는다
    # 따라서 comma로 구분된 여러 개의 조건식들이 있어도 & 연산자를 사용한 것과 동일한 취급을 받는다

    # comma로 구분된 조건식을 연결하기 위한 연산자를 지정한다
    op_quo = rlang::as_quosure(quote(`&`), rlang::base_env())
    op = rlang::quo_get_expr(op_quo)

    # comma로 나누어진 조건식들을 & 연산자로 묶는다
    expr = purrr::reduce(dots, function(x, y) rlang::expr( (!!op)( (!!x), (!!y) ) ))

    # 새로운 quosure를 생성한다
    quo_ = rlang::new_quosure(expr, rlang::quo_get_env(op_quo))

  }

  filter_impl = function(df, quosure) {
    ## 실제 dplyr에서는 이 부분이 C++로 되어 있다
    ## 실행되지 않고 캡쳐되어있는 quosure를 대상으로하는 data.frame 에서 실행시킨다

    # 인자로 주어진 조건문을 목표로 하는 data.frame에서 실행시킨다 (data.frame -> Logical)
    index = rlang::eval_tidy(quosure, data = df)

    # 결과로 주어진 인덱스를 바탕으로 원하는 row로만 필터링한다
    df[index,]
  }

  return(filter_impl(.data, quo_))
}
```

### 확인

```r
# pipe 연산자를 사용하기 위해 magrittr 패키지에서 함수를 가져온다
`%>%` = magrittr::`%>%`

iris %>%
  custom_filter(Sepal.Length > 7.5)
#     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
# 106          7.6         3.0          6.6         2.1 virginica
# 118          7.7         3.8          6.7         2.2 virginica
# 119          7.7         2.6          6.9         2.3 virginica
# 123          7.7         2.8          6.7         2.0 virginica
# 132          7.9         3.8          6.4         2.0 virginica
# 136          7.7         3.0          6.1         2.3 virginica

iris %>%
  custom_filter(Species == 'setosa', Sepal.Length > 5.5)
#    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# 15          5.8         4.0          1.2         0.2  setosa
# 16          5.7         4.4          1.5         0.4  setosa
# 19          5.7         3.8          1.7         0.3  setosa

iris %>%
  custom_filter(Sepal.Length > 7.5 | Petal.Length > 6.5)
#     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
# 106          7.6         3.0          6.6         2.1 virginica
# 118          7.7         3.8          6.7         2.2 virginica
# 119          7.7         2.6          6.9         2.3 virginica
# 123          7.7         2.8          6.7         2.0 virginica
# 132          7.9         3.8          6.4         2.0 virginica
# 136          7.7         3.0          6.1         2.3 virginica
```

## (작성중) select

select 함수의 주요 기능

- 원하는 컬럼만 추출하거나 컬럼의 순서를 변경, 또는 컬럼 이름을 변경할 수 있다
- 특정 열을 쉽게 선택할 수 있는 helper function을 사용할 수 있다

```r
custom_select = function(.data, ...) {
  # dplyr:::select.data.frame 참고하여 작성
  quos_ = rlang::quos(...)
  qquos_ = rlang::quos( !(!(!quos_)) )

  # variable context ???
  variable_context = new.env()

  set_current_variable_context = function(x) {
    stopifnot(is.character(x) || is.null(x))
    old = variable_context$selected
    variable_context$selected = x
    invisible(old)
  }

  ## (1) tidyselect::vars_select 구현 ##
  var_names = names(.data)
  if(!length(qquos_)) {
    # 인자가 없을 경우 반환할 내용?!
    vars_selected = tidyselect:::empty_sel(var_names, character(), character())
  }

  names_list = purrr::set_names( as.list(seq_along(var_names)), var_names )
  first = rlang::f_rhs(quos_[[1]])

  ind_list = tidyselect:::vars_select_eval(var_names, qquos_)

  # 첫 번째 구문에 "-" 표기가 되어있는지 확인한다
  initial_case = if (rlang::is_call(first, '-', n = 1)) {
    list(seq_along(var_names))
  } else {
    integer(0)
  }

  ind_list = c(initial_case, ind_list)
  names(ind_list) = c(rlang::names2(initial_case), rlang::names2(qquos_))
  ind_list = purrr::map_if(ind_list, purrr::is_character, tidyselect:::match_var, table = var_names)

  ####  TODO ####

  ## (2) dplyr::select_impl 구현 ##
}
```
