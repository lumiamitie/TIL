# AWS S3 + Cloudfront 사용시 발생하는 CORS 에러

## 문제상황

- JS에서 AWS S3 (CDN은 Cloudfront 사용) 에 올려놓은 JSON을 GET 요청을 통해 가져가려고 한다
- 다음과 같이 CORS 문제가 발생하여 에러가 발생했다

```
#### Error 1 ####
Access to XMLHttpRequest at 'https://....json' from origin 'https://...com' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.

#### Error 2 ####
GET https://....json net::ERR_FAILED
```

## 해결방법

- S3와 Cloudfront 에서 GET 메서드에 대한 CORS 처리만 열어두기로 했다

### S3 설정

- Bucket에서 "권한" > "CORS(Cross-origin 리소스 공유)" > "편집"
- 원하는 설정 정보를 입력하고 저장한다
    - GET 메서드만 열어두기 위한 설정 (JSON)
        
```json
[
    {
        "AllowedHeaders": [],
        "AllowedMethods": [
            "GET"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": []
    }
]
```
        

### Cloudfront 설정

- Behaviors 탭에서 항목 선택 후 Edit 버튼을 누른다
- Cache Based on Selected Request Headers 항목을 **Whitelist** 로 변경하고 아래 3개의 해더를 허용한다
    - Access-Control-Request-Headers
    - Access-Control-Request-Method
    - Origin

# 참고자료

[CORS(Cross-Origin Resource Sharing)](https://docs.aws.amazon.com/ko_kr/sdk-for-javascript/v2/developer-guide/cors.html)

[Creating a cross-origin resource sharing (CORS) configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ManageCorsUsing.html)

[S3에 적용한 CORS를 CloudFront 에 적용하는 방법](https://blog.munilive.com/posts/apply-cors-cloudfront-applied-s3.html)
