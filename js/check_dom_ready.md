# DOM 문서가 준비되었는지 확인하기

## HTML 웹페이지 라이프 사이클

HTML 페이지의 라이프 사이클에서 크게 세 가지 중요한 이벤트가 있다.

- `DOMContentLoaded` : 브라우저가 HTML은 불러와서 DOM 트리 구성을 완료했지만, img 태그나 스타일시트같은 외부 리소스는 로드되지 않았을 수 있다
    - DOM 노드를 제어할 수 있게 된다
    - jQuery의 `ready` 메서드는 이 단계를 체크한다
    - IE8 이하에서는 동작하지 않는다
- `load` : HTML 뿐만 아니라 외부 리소스까지 로드 완료된 상태이다
    - image 사이즈 등의 정보를 얻을 수 있다
- `beforeunload` : 유저가 페이지를 떠나려고 할 때 발생한다
    - 변화된 내용을 저장했는지 확인하고 페이지를 정말로 떠나고자 하는지 여부를 물어볼 수 있다
- `unload` : 유저가 페이지를 떠나기 직전에 발생한다
    - 페이지의 통계 수치를 보내는 등 일부 동작을 수행할 수 있다


## DOM 로딩이 완료되었는지 확인하기

### addEventListener 사용하기

- 모던 브라우저(및 IE 9+)에서는 다음과 같은 코드를 통해 확인할 수 있다

```javascript
document.addEventListener("DOMContentLoaded", function(){
    // Handler when the DOM is fully loaded
});
```

- IE8 이하에서 동작하는 코드가 필요하다면 다음 링크를 참고하자
    - <http://beeker.io/jquery-document-ready-equivalent-vanilla-javascript>


### readyState 값 확인하기

- 하지만 이벤트를 사용하는 경우 페이지를 로딩할 때만 동작할 것이다
    - 콜백 함수의 내용을 원할 때마다 실행시키고 싶다면 어떻게 해야 할까?
    - `document.readyState` 의 값을 통해 확인할 수 있다
- `document.readyState` 는 다음과 같은 세 가지 값을 가질 수 있다
    - `loading` : 다큐먼트 로딩 중
    - `interactive` : 문서의 로딩이 끝나고 해석 중이지만 이미지, 스타일시트, 프레임 등 리소스는 로딩하고 있는 상태
    - `complete` : 문서와 모든 하위 리소스의 로딩이 완료된 상태 (load 이벤트가 발생하기 직전)
- `readyState` 값이 바뀔 때 `document` 에서 `readystatechange` 이벤트가 발생한다


# 참고

- [Document.readyState](https://developer.mozilla.org/ko/docs/Web/API/Document/readyState)
- [DOMContentLoaded, load, unload :: 마이구미](https://mygumi.tistory.com/281)
- [Page: DOMContentLoaded, load, beforeunload, unload](http://javascript.info/onload-ondomcontentloaded)
- [Quick Tip: Replace jQuery's Ready() with Plain JavaScript - SitePoint](https://www.sitepoint.com/jquery-document-ready-plain-javascript/)
