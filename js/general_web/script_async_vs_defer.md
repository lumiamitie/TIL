# async vs defer

script 태그를 통해 비동기적으로 스크립트를 로딩하려면 async 또는 defer를 사용할 수 있다.

1. `<script>`
    - HTML 파싱을 멈추고 스크립트를 로딩한다.
    - 스크립트 로딩이 끝나면 스크립트를 실행한다.
    - 스크립트 실행이 끝나면 HTML 파싱을 계속 진행한다.
2. `<script async>`
    - HTML 파싱 중에 스크립트를 로딩한다.
    - 스크립트 로딩이 끝나면 HTML 파싱을 멈추고 스크립트를 실행한다.
    - 스크립트 실행이 끝나면 HTML 파싱을 계속 진행한다.
3. `<script defer>`
    - HTML 파싱 중에 스크립트를 로딩한다.
    - HTML 파싱이 완료되면 스크립트를 실행한다.
    - 문서에 정의된 순서대로 실행한다는 것을 보장한다.

# 참고자료

[async vs defer attributes](https://www.growingwiththeweb.com/2014/02/async-vs-defer-attributes.html)
