# plumber 에서 CORS 처리하기

plumber 에서 CORS 처리를 하려면 다음과 같이 필터를 추가한다.

```r
#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Test GET Method : Look up a product.
#* @param id
#* @get /products/<id>
function(id) {
    list(result = id)
}
```

다음 API 호출 결과에서 CORS 필터 추가 전후를 비교해보면, 필터를 추가한 뒤에는 헤더에 `Access-Control-Allow-Origin: *` 라는 부분이 추가된 것을 확인할 수 있다.

```
### 
GET http://127.0.0.1:8989/data/products/plumber

#### CORS 추가 전 ####
# HTTP/1.1 200 OK
# Date: Tue, 19 Jan 2021 13:18:21 GMT
# Content-Type: application/json
# Connection: close
# Content-Length: 22

# {
#   "result": [
#     "plumber"
#   ]
# }

#### CORS 추가 후 ####
# HTTP/1.1 200 OK
# Date: Tue, 19 Jan 2021 13:19:27 GMT
# Access-Control-Allow-Origin: *
# Content-Type: application/json
# Connection: close
# Content-Length: 22

# {
#   "result": [
#     "plumber"
#   ]
# }
```

# 참고자료

[plumber document : Cross-Origin Resource Sharing](https://www.rplumber.io/articles/security.html#cross-origin-resource-sharing-cors)
