# plumber를 사용해 간단한 API 서버 구성하기

## R plumber 개발 환경 구성하기

RStudio에서 제공하는 plumber 도커 이미지를 바탕으로 개발 환경을 구성한다. 
`rstudio/plumber` 이미지를 사용하면 최신 버전의 R과 plumber가 세팅된 환경을 바로 사용할 수 있다.
컨테이너 내부에서 테스트용 개발을 진행하기 위해, 임의의 컨테이너를 생성하고 내부에 진입하여 스크립트를 작성한다.

```bash
docker pull rstudio/plumber
docker run -it --rm --entrypoint /bin/bash rstudio/plumber
```

## 간단한 스크립트 작성해보기

총 3개의 스크립트를 작성한 뒤에 API 서버를 동작시켜보자.

### data.R

```r
#* Test GET Method : Look up a user.
#* @param id
#* @get /users/<id>
function(id) {
    list(result = id)
}

#* Test GET Method : Look up a product.
#* @param id
#* @get /products/<id>
function(id) {
    list(result = id)
}
```

### plot.R

```r
#* Return a plot of iris dataset.
#* @get /iris
#* @serializer png
function() {
    plot(iris)
}
```

### run.R

```r
library(plumber)

root <- pr()

data_api <- pr("data.R")
plot_api <- pr("plot.R")

root %>%
    pr_mount("/data", data_api) %>%
    pr_mount("/plot", plot_api)

root %>% pr_run(port=8989)
```

## API 서버 실행

이제 `run.R` 스크립트를 실행시켜보자. `/__docks__/` 로 접근하면 스웨거 페이지로 진입할 수 있다.

```bash
$ Rscript run.R
# Running plumber API at http://127.0.0.1:8989
# Running swagger Docs at http://127.0.0.1:8989/__docs__/
```

앞서 작성했던 항목들을 하나씩 테스트해 보면 정상적으로 동작하는 것을 확인할 수 있다.

```
### 
GET http://127.0.0.1:8989/data/users/miika

# HTTP/1.1 200 OK
# Date: Mon, 18 Jan 2021 12:58:28 GMT
# Content-Type: application/json
# Connection: close
# Content-Length: 20

# {
#   "result": [
#     "miika"
#   ]
# }

### 
GET http://127.0.0.1:8989/data/products/plumber

# HTTP/1.1 200 OK
# Date: Mon, 18 Jan 2021 12:59:02 GMT
# Content-Type: application/json
# Connection: close
# Content-Length: 22

# {
#   "result": [
#     "plumber"
#   ]
# }

### 
GET http://127.0.0.1:8989/plot/iris
```

# 참고자료

- [R plumber Documents](https://www.rplumber.io/)
- [R로 만든 머신러닝 모델을 API로 제공하기](https://mrchypark.github.io/r-api-with-plumber/)
