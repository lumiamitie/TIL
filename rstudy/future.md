# Future Basics in R

```r
library('future')
```

## Explicit vs Implicit Futures

### Explicit Futures

```r
f = future({
  cat('Resolving...\n')
  3.14
})
v = value(f)
v
```


### Implicit Futures

- `<-` , `=` 연산자 대신 `%<-%` 를 사용하여 정의한다.
- 이 경우에는 `futureOf` 함수를 사용하여 future 객체를 다시 반환받을 수 있다.
- 1) future를 생성하고 2) 완료되었을 때 값을 가져오는 두 단계 과정을 한 번에 처리한다

```r
v %<-% {
  cat('Resolving...\n')
  3.14
}
```


## Multiprocess Futures

```r
f <- future({
  samples <- rnorm(10000000)
  mean(samples)
}) %plan% multiprocess
w <- value(f)
w
```


f가 종료되기 전이라면 resolve(f) 는 FALSE가 반환된다

```r
f_dots <- function() {
  f <- future({
    s <- rnorm(10000000)
    mean(s)
  }) %plan% multiprocess
  
  while (!resolved(f)) {
    cat('..')
  }
  cat('\n')
  value(f)
}

f_dots()
```
