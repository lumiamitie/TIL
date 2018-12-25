# Error Handling in R

## 1. Base R Error Handling

- 여기서는 다음 문서의 base::tryCatch 부분을 정리하였다.
    - [Vignettes : tryCatchLog-intro](https://cran.r-project.org/web/packages/tryCatchLog/vignettes/tryCatchLog-intro.html)
- 추가로 참고할 문서들
    - [Advanced R : Beyond Exception Handling](http://adv-r.had.co.nz/beyond-exception-handling.html)

### (1) 에러 발생시키기

`base::stop` 을 통해 에러를 발생시킬 수 있다

```r
if (TRUE) {
  stop('Something is wrong!')  
}
# Error: Something is wrong!
```

에러메세지를 정의할 필요가 없다면 `base::stopifnot` 을 사용할 수 있다

```r
stopifnot(1 == 0)
# Error: 1 == 0 is not TRUE
```

경고 메세지를 보내고자 할 때는 `base::warning` 을 사용한다

```r
warning("Don't forget to commit")
# Warning message:
#   Don't forget to commit
```

### (2) 에러에 대응하기

#### (2.1) try

`base::try` 함수를 사용할 경우, 에러를 무시하고 다음 동작을 진행하는 방식으로 대응한다.

```r
(function() {
  stop('Stop this action!!!!')
  print('the error was ignored')
})()
# Error in (function() { : Stop this action!!!!

(function() {
  try(stop('Stop this action!!!!'), silent = TRUE)
  print('the error was ignored')
})()
# [1] "the error was ignored"
```

#### (2.2) tryCatch

`tryCatch` 를 사용하면 콜백 함수를 통해 원하는 방식으로 에러에 대응할 수 있다.
error, warning, message 에 대응할 수 있다.

```r
tryCatch({ stop('Stop this action!!!!!')},
         error = function(err) print('An error occured'))
# [1] "Error Handled"

tryCatch({ warning('Be careful!') },
         warning = function(w) print('Catching Worning Message'))
# [1] "Catching Worning Message"

tryCatch({ message('Testing') },
         message = function(msg) print( trimws(msg$message) ))
# [1] "Testing"
```

### (3) 사용자 정의 에러

직접 특정한 에러를 정의하고 싶다면 `condition` 클래스를 가지는 객체를 만들면 된다.
그리고 `base::signalCondition()` 함수를 통해 원하는 곳에서 실행시킨다.

우선 사용자 정의 에러를 생성하는 함수를 구성해보자.

- 첫 번째 인자는 만들고자 하는 에러의 클래스명
- 두 번째 인자는 에러가 발생했을 때 출력할 메세지로 정의했다

```r
custom_error = function(subclass, message, call = sys.call(-1), ...) {
  structure(
    class = c(subclass, 'condition'),
    list(message = message, call = call, ...)
  )
}
```

에러를 만들어보자

```r
test_error = custom_error('test_error', 'An Error occured while test')
```

tryCatch를 통해 확인해보면 `test_error` 에 발생했을 때 사전에 정의된 함수가 실행되는 것을 볼 수 있다.

```r
tryCatch({
    signalCondition(test_error)
    print('Test Done!')
  },
  test_error = function(err) { print(err$message) }
)
# [1] "An Error occured while test"
```

**TODO : tryCatch의 단점 및 해결방안!**
