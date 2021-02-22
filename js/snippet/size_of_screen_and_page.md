# JS로 화면 및 페이지 크기 구하기

- JS로 브라우저/디바이스의 화면 크기와 페이지 크기 등을 구하려면 어떻게 해야 할까?

```javascript
function sizes() {
  let contentWidth = [...document.body.children].reduce( 
    (a, el) => Math.max(a, el.getBoundingClientRect().right), 0) 
    - document.body.getBoundingClientRect().x;

  return {
    // window : 현재 화면의 윈도우 크기
    // windowWidth, windowHeight를 계산할 때 스크롤바는 제외하고 계산한다
    windowWidth:  document.documentElement.clientWidth,
    windowHeight: document.documentElement.clientHeight,
    // page : 현재 화면의 전체 페이지 크기
    // pageWidth와 pageHeight 는 body의 margin을 0으로 가정하고 계산한 결과이다
    pageWidth:    Math.min(document.body.scrollWidth, contentWidth),
    pageHeight:   document.body.scrollHeight,
    // screen : 화면 크기
    // macOS의 경우 시스템 메뉴바의 크기까지 포함한다
    screenWidth:  window.screen.width,
    screenHeight: window.screen.height,
    // 현재 윈도우를 기준으로 page의 시작점(0,0)이 어디에 있는지 계산
    pageX:        document.body.getBoundingClientRect().x,
    pageY:        document.body.getBoundingClientRect().y,
    // 스크린 원점이 어디에 있는지 계산
    // screenY의 경우 직관적으로 원하는 값을 정확하게 구하는 것이 어려운 것 같다
    screenX:     -window.screenX,
    screenY:     -window.screenY - (window.outerHeight-window.innerHeight),
  }
}

sizes()
```

# 참고자료

[Get the size of the screen, current web page and browser window](https://stackoverflow.com/a/62278401)
