# R에서 조건부 에러 처리하기

R에서 특정한 에러에 대해서만 따로 예외 처리를 하려면 어떻게 해야 할까? `rlang::abort` 를 통해 에러를 발생시킬 경우에는 쉽게 처리할 수 있다.

```r
# 에러 발생
rlang::abort("Something wrong happend")

# "bad_error" 클래스를 가지는 에러를 발생시킨다
# class 파라미터에 특정한 에러 클래스를 부여한다
rlang::abort("Something wrong happend", class = "bad_error")
```

위와 같이 특정한 클래스를 가지는 에러를 발생시키면, `tryCatch` 함수를 통해 해당 케이스를 별도로 예외 처리할 수 있다.

```r
# Handling errors with condition 

# (1) 일반적인 에러 발생
tryCatch({
  rlang::abort("Something wrong happend")
}, bad_error = function(err) {
  print("This is a bad error")
}, error = function(err) {
  print("This is a simple error")
})
# [1] "This is a simple error"

# (2) "bad_error" 클래스의 에러 발생
# - 참고: 일반 error에 대한 처리가 맨 마지막에 와야 한다
tryCatch({
  rlang::abort("Something wrong happend", class = "bad_error")
}, bad_error = function(err) {
  print("This is a bad error")
}, error = function(err) {
  print("This is a simple error")
})
# [1] "This is a bad error"
```

# 참고자료

- [rlang document : Signal an error, warning, or message](https://rlang.r-lib.org/reference/abort.html)
- [Handling R errors the rlang way](https://www.onceupondata.com/2018/09/28/handling-r-errors/)
