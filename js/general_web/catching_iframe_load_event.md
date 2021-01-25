# iframe 엘리먼트에 추가한 load 이벤트 리스너가 동작하지 않는 문제

## 문제상황

- iframe 엘리먼트를 생성하고 해당 엘리먼트가 로딩이 완료되었을 때 데이터를 전달하기 위해 load 이벤트 리스너를 추가했다
- 콘솔에서는 잘 동작하는데, 스크립트 업로드 후에는 실제 동작을 하지 않는 문제가 발견되었다

```javascript
//// 기존 방식 ////
// - iframe 생성 후 load 이벤트에 동작할 내용을 콜백 함수로 정의한다
var iframe = document.createElement("iframe");
var body = document.getElementsByTagName("body")[0];
iframe.src = src;
iframe.sandbox = 'allow-scripts allow-same-origin';

iframe.addEventListener('load', function(event) {
    var host = new URL(document.URL).hostname;
    var data = { contents: ['something', 'to', 'send'] };
    var targetOrigin = new URL(redirectURL).origin;
    // Parent -> Child로 필요한 데이터 전송
    iframe.contentWindow.postMessage(JSON.stringify(data), targetOrigin);
}, false)

body.appendChild(iframe);
```

## 해결방법

- **iframe 안과 밖의 origin이 다르기 때문에, load 이벤트가 전파되지 않는다**고 한다
- 따라서 부모 프레임에서 전달해주는 message를 기다리는 대신, **iframe 내부의 페이지에서 load 이벤트가 발생할 때 부모 프레임으로 필요한 정보를 바로 발송한다.**

```javascript
//// 변경 후 ////
var iframe = document.createElement("iframe");
var body = document.getElementsByTagName("body")[0];
iframe.src = src;
iframe.sandbox = 'allow-scripts allow-same-origin';

// 필요한 로직은 전부 iframe 내부로 넘겨버림

body.appendChild(iframe);
```

# 참고자료

[Container of iFrame not catching events, even during capture phase](https://stackoverflow.com/a/50519542)
