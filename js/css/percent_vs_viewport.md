# CSS의 단위들 : % vs Viewport Units

## & vs Viewport Units

- `%` 는 **부모 엘리먼트와** 비교했을 때 상대적인 값을 나타낸다
- vw, vh, vmin, vmax 는 **Viewport를** 기준으로 상대적인 값을 나타낸다

참고자료

- [MDN - CSS 값 과 단위](https://developer.mozilla.org/ko/docs/Learn/CSS/Building_blocks/Values_and_units)
- [CSS vh / vw의 능숙한 반응형 웹사이트제작를 제작하자!](https://taimouse.tistory.com/8)
- [CSS의 7가지 단위 - rem, vh, vw, vmin, vmax, ex, ch](https://webclub.tistory.com/356)

## 100% vs 100vh 100vw

body의 너비, 높이를 100% 로 지정하는 것과 100vh, 100vw 로 지정하는 것은 어떻게 다를까?

- viewport 단위는 스크롤바 영역을 포함한다
    - 따라서 너비를 100vh 로 설정할 경우 스크롤바가 생성될 수 있다
- %는 스크롤바 영역을 포함하지 않는다
    - 너비를 100%로 설정하더라도 스크롤바가 존재할 영역이 남아있다

참고자료

- [vh/vw와 %의 차이](https://graykick.tistory.com/8)
