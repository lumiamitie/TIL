# 팝업/배너 등이 떠있을 때 메인 페이지 스크롤 방지

- 팝업, 모달, 배너 등이 화면에 떠있을 때 바닥에 깔려있는 메인 페이지가 스크롤되지 않도록 막아야 하는 경우가 있다
    - 또는 반대로 스크롤되도록 허용해야 하는 경우도 있다
- CSS를 통해 간단히 해결할 수 있다
    - `body` 태그에 `overflow: hidden;` 스타일을 추가한다
    - 위 속성을 사용하면 하위 태그의 컨텐츠가 body의 영역을 넘어갔을 때 보이는 부분만을 보여준다
    - 이 과정에서 스크롤이 막히기 때문에 스크롤을 방지하는 역할로 사용할 수 있다

# 참고자료

- [MDN: overflow](https://developer.mozilla.org/ko/docs/Web/CSS/overflow)
- [Prevent Page Scrolling When a Modal is Open | CSS-Tricks](https://css-tricks.com/prevent-page-scrolling-when-a-modal-is-open/)
- [모달 팝업뜰때 바닥 스크롤 막기](https://velog.io/@naynara/모달-팝업뜰때-바닥-스크롤-막기)
