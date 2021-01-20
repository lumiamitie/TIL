# R promises 라이브러리를 사용한 비동기 처리

## 해결해야 하는 문제

DB에 요청한 데이터를 반환하는 함수를 비동기로 처리하려면 어떻게 해야 할까? `future` 와 `promises` 라이브러리를 통해 해결해보자.

```r
library(future)
library(promises)

# Background R Session을 생성하여 future block의 비동기 로직을 처리한다
plan(multisession)

# 비동기로 동작해야 하는 함수를 정의한다
fetch_data <- function() {
  con <- DBI::dbConnect(RMariaDB::MariaDB(), host = "host", user = "user", password = "password")  
  data <- DBI::dbGetQuery(con, "SELECT col1, col2, col3 FROM database.table")
  on.exit({
    DBI::dbDisconnect(con)
  })
  data
}
```

다음과 같이 두 가지 방식으로 사용할 수 있다.

1. `then` 함수를 통해 비동기 로직을 처리한다
2. promise pipe를 통해 비동기 로직을 처리한다

```r
# (1) then
future({ fetch_data() }) %>% 
  then(
    onFulfilled = function(data) {
      print( jsonlite::toJSON(data) )
    }, onRejected = function(err) {
      print(err)
    }
  )

# (2) promise pipe
# %...>% : Promise pipe (for onFulfilled part)
# %...!% : Error handling pipe operator
future({ fetch_data() }) %...>% 
  { print(jsonlite::toJSON(.)) } %...!% 
  { print(.) }
```

## 주의사항

부모 프로세스에서 생성한 DB connection 객체를 Future 코드 블럭 내에서 사용할 수 없다.
따라서 DB 컨넥션을 맺고 데이터를 가져와서 컨넥션을 끊는 작업 모두가 `future({ ... })` 블록 내에서 이루어져야 한다.

> Future code blocks cannot use resources such as database connections and network sockets that were created in the parent process.

- [futures 라이브러리의 vignettes 문서](https://cran.r-project.org/web/packages/promises/vignettes/futures.html)
- [Github rstudio/pool Issue #83](https://github.com/rstudio/pool/issues/83)

# 참고자료

- [R Promises 라이브러리 공식 문서](https://rstudio.github.io/promises/index.html)
