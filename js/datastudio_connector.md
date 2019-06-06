# Google Data Studio Community Connector 만들기

[Codelab](https://codelabs.developers.google.com/codelabs/community-connectors/) 의 내용을 정리해보자.

목표는 사내망의 데이터를 데이터스튜디오에 바로 연결하는 것!

## Community Connector Workflow

기본적인 커뮤니티 컨넥터의 경우 다음과 같은 네 가지 함수를 정의해야 한다.

- `getAuthType()`
- `getConfig()`
- `getSchema()`
- `getData()`

컨넥터 내부에서는 아래와 같은 흐름으로 진행된다.

![png](https://codelabs.developers.google.com/codelabs/community-connectors/img/962155b82be8de99.png)

## Apps Script 프로젝트 설정하기

[Google Apps Script](https://script.google.com/) 페이지에 방문하여 새로운 스크립트를 생성한다.
