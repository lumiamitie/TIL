# window 에서 click 이벤트를 걸어도 반응하지 않는 문제

- window 객체에 클릭 이벤트 리스너를 추가했다
- 그런데 특정 엘리먼트에서는 `useCapture` 옵션에 따라 click 이벤트가 트리거되지 않는 경우가 있었다.
    - true 일 경우 click 이벤트가 트리거되었다.
    - false 일 경우 click 이벤트가 트리거되지 않았다.
- 참고로 해당 엘리먼트에는 onclick 프로퍼티를 통해 클릭 이벤트에 대한 트리거가 추가되어 있었다.

왜 이런 일이 발생했을까? 다음과 같은 심증이 들어서 테스트해보기로 했다.

> 클릭 대상에 걸려있는 a태그에 onclick 함수가 걸려있는데, 여기서 propagation을 막고 있는게 아닐까?

## 테스트해보자

- JSFiddle 에서 다음과 같이 테스트 환경을 세팅했다
    - 특정 엘리먼트를 클릭했을 때 onclick 함수를 설정하고, stopPropagation 으로 이벤트 전파를 막는다.
    - useCapture 옵션을 true와 false로 바꾸어보며 이벤트가 전파되는지 확인한다.

```html
<!-- HTML -->
<a class="target" href="#" onclick="evtPreventPropagation(event)">link</a>
<p id="is-clicked">FALSE</p>
```

```javascript
// Javascript
function evtPreventPropagation(e) {
  console.log('Prevent Propagation!!')
  e.stopPropagation()

  // preventDefault 로는 propagation이 막히지 않는다
  // e.preventDefault()
}

function clickHandler(e) {
  if (Array.from(e.target.classList).includes('target')) {
  	console.log('click event!')
    document.querySelector('#is-clicked').textContent = 'TRUE'
  }
}

// useCapture=true 일 경우 link를 클릭하면 TRUE로 바뀐다
window.addEventListener('click', clickHandler, true)

// useCapture=false 일 경우 link를 클릭해도 TRUE로 바뀌지 않는다
window.addEventListener('click', clickHandler, false)
```

## 테스트 결과

- `Event.stopPropagation` 이 온클릭 이벤트 중에 발생할 경우, 클릭 이벤트가 window 객체로 전파되는 것을 막는다.
- 따라서 window 객체에 걸어둔 클릭 이벤트 리스너로는 클릭 이벤트를 잡아낼 수 없게 된다.
- 이 때 window 객체에 클릭 이벤트 리스너를 추가할 때 `useCapture=true` 로 설정하면, 이벤트 전파가 막히기 전에 클릭 이벤트를 수신하게 되어 콜백 함수가 동작한다.

# 참고자료

- 아래 글에서는 Side Effect를 발생시키지 않는 로깅 작업에는 `useCapture=true` 를 사용할 것을 추천하고 있다.
    - [Simple Custom Event Listeners With Google Tag Manager](https://www.simoahava.com/analytics/simple-custom-event-listeners-gtm/)
