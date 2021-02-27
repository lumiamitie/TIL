# POST 요청이 서버에서 OPTIONS 로 도달하는 문제

## 문제상황

- POST로 요청을 했는데 서버에는 OPTION 으로 도착하고 있다고 한다
- 어떻게 된 일일까..?

```javascript
function postRequest (window, endPoint) {
    try {
        var req = new XMLHttpRequest(endPoint);
        req.open("POST", endPoint);
        req.addEventListener("onreadystatechange", function(event) {
            if (req.readyState === 4 && req.status !== 200) {
                console.log('Request is done, but status is not equal to 200.')
            }
        });
        req.setRequestHeader("Content-type", "application/json");
        req.send(JSON.stringify({
            result : "success",
            timestamp: Date.now(),
        }));
    } catch (e) {
        console.log('Request failed.')
    }
};
```

## 원인

- 요청을 받는 서버에서 CORS 처리가 되어있지 않은 경우 OPTION으로 도착할 수 있다고 한다
- "Simple Request" 가 아닌 경우, CORS 요청 이전에 OPTION 메서드로 preflight 요청을 보내게 된다
- "Simple Request" 는 다음과 같은 조건을 모두 만족해야 한다
    - GET, HEAD, POST 메서드에서만 가능하다
    - CORS-safelisted request-header 를 사용한다
    - 다음 세 가지 Content-Type 을 사용한다
        - `application/x-www-form-urlencoded`
        - `multipart/form-data`
        - `text/plain`

## 해결 방법
- POST 요청이 가지 않는 것은 CORS 처리를 하면 해결되었다
- OPTION preflight 요청을 보내지 않도록 하려면 요청을 "Simple Request"로 변환하는 것이 가장 간단한 방법인 것 같다

# 참고자료

- [StackOverflow | Why is an OPTIONS request sent and can I disable it?](https://stackoverflow.com/a/29954326)
- [StackOverflow | XMLHttpRequest changes POST to OPTION](https://stackoverflow.com/a/8154264)
- [MDN | OPTIONS](https://developer.mozilla.org/ko/docs/Web/HTTP/Methods/OPTIONS#preflighted_requests_in_cors)
- [Handling "XMLHttpRequest" OPTIONS Pre-flight Request in Laravel](https://medium.com/@neo/handling-xmlhttprequest-options-pre-flight-request-in-laravel-a4c4322051b9)
