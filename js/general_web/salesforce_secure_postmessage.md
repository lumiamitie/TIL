# Salesforce developers : Secure Coding PostMessage

다음 문서를 가볍게 요약.

[Salesforce Developers | Secure Coding PostMessage](https://developer.salesforce.com/docs/atlas.en-us.secure_coding_guide.meta/secure_coding_guide/secure_coding_postmessage.htm)

## Sender

```javascript
otherWindow.postMessage(message, targetOrigin);
// window.postMessage("This is a message", "https://www.target-origin.io")
```

- `message`
    - 목표로 하는 윈도우로 보낼 실제 메세지를 의미한다
    - 모든 객체를 사용할 수 있다
    - 참고: IE에서는 문자열만 사용할 수 있기 때문에 `JSON.stringify` 를 적용해야 한다
- `targetOrigin`
    - 메세지가 도착해야 하는 윈도우의 origin을 의미한다
    - `"*"` 로 입력하는 경우 도메인과 상관없이 모든 윈도우에 전송할 수 있지만, 보안상 문제가 있다
    - 항상 특정한 origin을 입력하는 것이 중요하다

## Receiver

- 허용된 도메인에서 전달된 메세지만 받도록 하는 것이 좋다
- 전달받은 데이터를 처리하기 전에 데이터 포맷을 검증하는 로직을 두는 것이 좋다
- 전달받은 메세지가 위험할 수 있다고 가정하고 방어적으로 개발해야 한다

```javascript
window.addEventListener("message", processMessages);
 function processMessages(event) {
    var sendingOrigin = event.origin || event.originalEvent.origin; 
    if (origin !== "https://www.target-origin.io") {
        // 메세지가 어디서 왔는지 확인한다
        // 메세지를 무시하거나 에러를 발생시킨다
        return;
    }
    if(isIncomingDataValid(event.data)) { 
        // isIncomingDataValid는 데이터 포맷을 검증하기 위한 임의의 함수를 의미한다
        do_something()
    } else {
        // 메세지를 무시하거나 에러를 발생시킨다
    }
 }
```
