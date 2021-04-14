# littler로 R 스크립트 실행할 때는 .Renviron 에 정의된 환경변수가 설정되지 않는다

## 문제상황

- 기본적으로 `.Renviron` 파일에 환경변수를 설정해두면 R이 실행될 때 해당 환경변수가 설정된 상태로 R이 실행된다.
- 그런데 `Rscript run.r` 이 아니라 littler 을 통해 `r run.r` 형태로 스크립트를 실행시킬 경우 환경변수가 불러와지지 않는 문제가 있다.

## 해결방법

### 1. littler 대신 Rscript 로 스크립트를 실행한다

```bash
# Using littler -> .Renviron 의 환경변수가 로딩되지 않는다.
r run.r

# Using Rsciprt -> .Renviron 의 환경변수가 로딩된다.
Rscript run.r
```

### 2. TODO? littler에서 그냥 스크립트를 실행할 수 있지 않을까...

TODO

[Github Issue | Renviron and littler](https://github.com/eddelbuettel/littler/issues/64)
