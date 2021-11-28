# 컨텐츠가 넘칠 때만 스크롤바 추가하기

## 문제 상황

`overflow: scroll` 을 사용할 경우 컨텐츠가 넘칠 경우에 스크롤바가 생기는데, 컨텐츠가 한 화면에 보일 때에도 스크롤바가 항상 생겨서 가독성을 해칠 수 있다. 이럴 때 컨텐츠가 넘칠 때만 스크롤바를 추가하려면 어떻게 해야할까?

## 해결 방법

- `overflow: auto` 로 설정한다.

```css
.content {overflow:auto;}
.content {overflow-y:auto;}
.content {overflow-x:auto;}
```

[CSS hide scroll bar if not needed](https://stackoverflow.com/questions/18716863/css-hide-scroll-bar-if-not-needed)
