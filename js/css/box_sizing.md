# 테두리와 여백까지 포함하여 정확한 컨텐츠 크기 설정하기 (CSS box-sizing)

## 문제 상황

- 작업하던 차트의 너비를 일정 px로 설정해두었는데, padding을 추가/제거할 때마다 전체 차트를 감싸는 div의 영역의 크기가 바뀌는 문제가 발생했다
- JS 코드를 통해서 처리할 수는 있는데, 더 간단한 방식이 없을까?

## 해결 방법

- CSS의 `box-sizing` 속성을 `border-box` 로 변경한다
- box-sizing 속성에는 두 가지 값을 적용할 수 있다
    - content-box : 컨텐츠 너비(or 높이) = 설정한 너비(or 높이) + padding + border
    - border-box : 컨텐츠 너비(or 높이) = 설정한 너비
        - border-box 의 경우 설정한 너비/높이 값에 padding과 border값이 포함된다
        - 따라서 padding이나 border값을 변경할 경우, 컨텐츠 영역의 크기가 자동으로 변경된다
- 아래 CSS 코드를 비교해보자
    - border-box 로 설정하는 경우 padding을 제외한 `#container` 의 영역은 20px x 20px 이 된다
    - content-box로 설정하는 경우 padding을 제외한 `#container` 의 영역은 80px x 80px 이 된다

```html
<!-- (1) box-sizing: border-box; -->
<style>
    body {
        margin: 0;
    }
    #container {
        box-sizing: border-box;
        padding: 30px;
        width: 80px;
        height: 80px;
    }
</style>
<div id="container"></div>

<!-- (2) box-sizing: content-box; -->
<style>
    body {
        margin: 0;
    }
    #container {
        padding: 30px;
        width: 80px;
        height: 80px;
    }
</style>
<div id="container"></div>
```

# 참고 자료

- [CSS : box-sizing 속성](https://kutar37.tistory.com/entry/CSS-box-sizing-%EC%86%8D%EC%84%B1)
- [box-sizing - 생활코딩](https://opentutorials.org/course/2418/13405)
