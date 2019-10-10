# HTTP Cookie

[HTTP Cookie와 관련된 MDN 문서](https://developer.mozilla.org/ko/docs/Web/HTTP/Cookies)를 정리해보자.

## 쿠키란?

- 서버에서 웹 브라우저로 전송하는 작은 데이터 조각
- 브라우저에서는 받은 쿠키를 저장했다가, 동일한 서버에 요청할 때 저장된 데이터를 함께 보낸다

## 쿠키가 왜 필요할까?

- 상태가 없는 HTTP 프로토콜에서 상태 정보를 기억하기 위해 사용한다
- 주로 다음과 같은 목적을 위해 사용한다
    - 세션 관리
    - 개인화
    - 사용자의 행동을 기록
- 현재는 쿠키보다 modern stroage API를 사용해서 정보를 저장하는 것을 권장한다
    - 쿠키는 모든 요청에 포함되어 전송되기 때문에 성능이 떨어지는 원인이 될 수 있다
    - 웹 스토리지 API (localStorage, sessionStorage) 와 IndexedDB 를 통해 정보를 클라이언트에 저장할 수 있다

# 쿠키 만들기

- 서버가 HTTP 요청에 대해 응답할 때 `Set-Cookie` 헤더를 추가할 수 있다
- `Expires` 혹은 `Max-Age` 값을 설정할 수 있다
    - 이 경우 영속적인 쿠키로 생성된다 (만료 시간은 서버가 아닌 클라이언트를 기준으로 한다)
    - 이 값이 명시되지 않으면 해당 쿠키는 세션 쿠키로 생성된다
- `Secure`
    - Secure 쿠키로 설정하면 HTTPS 프로토콜 상에서 암호화된 요청인 경우에만 전송된다
    - Secure 쿠키라도 민감한 정보를 전달해서는 안된다
- `HttpOnly`
    - HttpOnly 쿠키는 Document.cookie 를 통해 접근할 수 없다
    - Cross-site 스크립팅 (XSS) 공격을 방지하기 위해 사용한다
