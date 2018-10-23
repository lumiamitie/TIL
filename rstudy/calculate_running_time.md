# 특정 코드의 실행시간을 계산하는 래퍼함수 만들기

ipython의 `%timeit` magic function처럼, 함수의 기본 동작을 방해하거나 로직을 수정하지 않으면서 함수가 동작하는데 걸리는 시간만 확인하고 싶은 경우가 있다. 특정 함수의 기능을 방해하지 않으면서 기능만 추가할 수 있는 래퍼 함수를 작성해보았다.

해당 함수는 다음과 같이 동작한다

- `code`가 주어지면 해당 코드를 실행시키지 않고 캡쳐만 해둔다.
- 타이머를 작동시킨다
- `rlang::eval_tidy()` 를 통해 캡쳐했던 코드를 동작시키고, 결과를 `result` 변수에 저장한다
- 타이머를 멈추고, 실행하는데 걸린 시간을 계산한다
- 원하는 자리수만큼 반올림하여 (기본값 2) 걸린 시간을 출력한다.
    - 자리수값이 NULL인 경우에는 반올림하지 않는다

```r
run_with_timespent = function(code, round.digit = 2) {
  expr = rlang::enquo(code)
  start_time = Sys.time()
  result = rlang::eval_tidy(expr)
  end_time = Sys.time()
  running_time = end_time - start_time
  if (!is.null(round.digit)) running_time = round(running_time, round.digit)
  message(paste("Code Running Time :", running_time, attr(running_time, "units")))
  
  return(result)
}
```

다음과 같이 사용할 수 있다.

```r
run_with_timespent(runif(10))
# Code Running Time : 0 secs
# [1] 0.785937428 0.009581189 0.223719805 0.018738284 0.443394794 0.397937197 0.390906666 0.872749984 0.786706020 0.280405956

run_with_timespent(runif(10), round.digit = NULL)
# Code Running Time : 0.000133275985717773 secs
# [1] 0.8507746 0.4417025 0.1106308 0.2640356 0.7084170 0.1423237 0.1139629 0.6896891 0.5060326 0.9606220
```
