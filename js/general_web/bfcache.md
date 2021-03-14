# Back/forward cache (bfcache)

다음 문서를 정리해보자.

[이전/다음 페이지 캐시](https://ui.toast.com/weekly-pick/ko_20201201)

## bfcache 란?

- 브라우저에서 이전/다음 페이지로 이동했을 때, 캐싱을 통해 페이지가 순간적으로 로드되도록 한다.
- 유저가 페이지를 이동하는 순간 페이지의 전체 스냅샷을 캐싱해두고, 사용자가 다시 돌아왔을 때 메모리에 저장해둔 페이지 정보를 바탕으로 빠르게 복원한다.
- 활성화 여부에 따른 차이
    - bfcache가 활성화되지 않은 경우
        - 이전 페이지를 불러오기 위해 새로운 요청을 시도한다
    - bfcache가 활성화된 경우
        - 이전 페이지를 즉시 복원한다
        - 메모리에 저장된 정보를 사용하기 때문에 네트워크를 사용하지 않는다

## bfcache를 확인하려면 어떻게 해야 할까?

- `PageTransitionEvent` 를 통해 bfcache 여부를 확인할 수 있다.
    - pageshow
    - pagehide

```javascript
window.addEventListener('pageshow', function(event) {
  if (event.persisted) {
    console.log('bfcache로 복원된 페이지');
  } else {
    console.log('캐싱 없이 정상적으로 로드된 페이지');
  }
});
```

## bfcache를 잘 적용하려면 어떤 것들을 고민해야 할까?

- unload 이벤트 사용하지 않기
    - unload 이벤트 리스너를 추가하면 Firefox에서 속도가 느려지고, Chrome과 Safari에서는 추가했던 대부분의 코드가 실행되지 않는다.
    - pagehide 이벤트를 대신 사용해보자.
- 필요한 경우 beforeunload 리스너는 추가할 수 있다
    - Firefox에서는 사용하지 않는 것을 권장한다.
    - 필요한 경우에만 리스너를 추가하고, 동작 후에는 리스너를 즉시 삭제하는 것을 권장한다.
- `window.opener` 참조를 사용하지 않기
    - `rel="noopener"` 를 추가하여 참조를 만들지 않도록 한다.
- 사용자가 다른 페이지를 탐색하기 전에 항상 열려 있는 연결을 종료하기
    - 다음과 같은 상황에서는 bfcache를 시도하지 않는다
        - 완료되지 않은 DB 트랜잭션이 존재하는 경우
        - 진행 중인 `fetch`, `XMLHttpRequest` 가 있는 경우
        - `WebSocket`, `WebRTC` 연결이 되어있는 경우

참고. GA 등 애널리틱스 도구에서 bfcache로 인해 페이지뷰 수가 줄어들 수 있다. 
pageshow 이벤트에서 persisted 속성을 확인해 수동으로 페이지뷰를 기록하는 방식으로 해결할 수 있다.

## bfcache 를 막는 방법

다음과 같이 헤더를 설정하면 bfcache를 막을 수 있다.

```
Cache-Control: no-store
```
