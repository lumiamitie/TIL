# `box` 를 사용한 R 스크립트 모듈화 방법
        
## 설치한 라이브러리에서 코드 불러오기

- box를 통해 라이브러리 또는 모듈에서 코드를 불러오려면 `box::use` 를 사용한다.
- `box::use` 의 기본적인 구조는 다음과 같다.

```r
box::use(
  ModuleName = LibraryName[FunctionToAttach, ...]
)

####
box::use(
  stringr,                        # 1
  CI = CausalImpact,              # 2
  magrittr[`%>%`, extract],       # 3
  glue = glue[glue, glue_sql],    # 4
  grf[train = causal_forest, ...] # 5
)

# 1
# stringr 라이브러리를 이름 그대로 불러온다.
stringr$str_detect()

# 2
# CausalImpact 라이브러리를 CI 라는 이름으로 불러온다.
CI$CausalImpact()

# 3
# magrittr 라이브러리의 다음 두 함수를 현재 env에 attach한다.
%>%
extract

# 4
# glue 라이브러리 전체를 모듈로 불러온다.
glue$glue()
glue$glue_sql()
glue$as_glue()

# 다음 두 함수는 현재 env에 attach한다.
glue()
glue_sql()

# 5
# causal_forest() 함수를 train() 으로 이름을 변경하여 env에 attach한다.
# 그 외 모든 함수는 그대로 env에 attach한다.
train()
```

- 참고로, `box::use` 는 실행된 함수 스코프 내에서만 유효하다.
- 다음과 같이 함수 내에서 필요한 함수만 불러올 수 있다.

```r
get_data_from_query <- function(connection, query, print_only = FALSE, ...) {
  box::use(
    DBI[dbGetQuery],
    glue[glue_sql],
    tidyr[as_tibble],
    magrittr[`%>%`]
  )
  glue_query <- glue_sql(query, .con = connection, ...)
  if (print_only) {
    print(glue_query)
    invisible(NULL)
  } else {
    dbGetQuery(connection, glue_query) %>% as_tibble()
  }
}
```

## 재사용 가능한 모듈 작성하기

- R 패키지에서 함수를 export 하는 방식과 유사하다.
- 별도의 R 스크립트 작성 후 export 디렉티브(`#' @export`)를 추가하면 된다.
- 다음과 같이 `common_scripts/connection.R` 파일을 작성할 수 있다.

```r
#' @export
athena <- function() {
  box::use(DBI[dbConnect])
  dbConnect(
    # Information to make DB connection
  )
}

#' @export
get_data_from_query <- function(connection, query, print_only = FALSE, ...) {
  box::use(
    DBI[dbGetQuery],
    glue[glue_sql],
    tidyr[as_tibble],
    magrittr[`%>%`]
  )
  glue_query <- glue_sql(query, .con = connection, ...)
  if (print_only) {
    print(glue_query)
    invisible(NULL)
  } else {
    dbGetQuery(connection, glue_query) %>% as_tibble()
  }
}
```

## 모듈에서 코드 불러오기

- 모듈에서 코드를 불러올 때는 코드가 동작하는 스크립트를 기준으로 path를 제공한다.
- 모듈 스크립트가 `app/common_scripts/connection.R` 에 있을 때 모듈에서 코드를 불러오는 방법은 다음과 같다.

```r
# app/test.R 에서 실행하는 경우
box::use(common_scripts/connection)
box::use(./common_scripts/connection)

# app/analysis/test.R 에서 실행하는 경우
box::use(../common_scripts/connection)
```

- 이후 코드를 실행하는 방식은 라이브러리를 불러올 때와 동일하다.

```r
box::use(common_scripts/connection)

con <- connection$athena()
test_data <- connection$get_data_from_query(
  # ...
)
```



# `modules` 와 `box` 를 사용한 모듈화 비교하기

## modules

```r
# src/data.R
import("DBI")
import("RMySQL")
import("lubridate")
import("dplyr")

export("get_data_from_db")

get_data_from_db <- function() {
    # ...
}
```

```r
# run.R
Module <- modules::use("src/data.R")
data <- Module$get_data_from_db()
```

## box
        
```r
# src/data.R
box::use(
    DBI[dbGetQuery],
    RMySQL,
    lubridate,
    dplyr
)

#' @export
get_data_from_db <- function() {
    # ...
}
```

```r
# run.R
box::use(Module = src/data)
data <- Module$get_data_from_db()
```
