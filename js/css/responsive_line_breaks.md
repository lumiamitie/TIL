# CSS로 작은 디바이스에서만 줄바꿈하려면 어떻게 해야 할까?

## 문제상황

- 반응형으로 페이지를 만들다 보니, 원치 않은 곳에서 줄바꿈이 일어나거나 줄바꿈이 없어서 가독성이 떨어지는 문제가 생겼다
- 원하는 크기의 디바이스에서만 강제로 줄바꿈 할 수 있는 방법이 있을까?

## 해결방법

다음과 같이 미디어 쿼리를 통해 원하는 화면 크기에서만 줄바꿈을 적용할 수 있다.

1. br 태그를 추가하고, 줄바꿈이 필요하지 않을 때는 `display: none;` 으로 숨긴다
2. 각 텍스트 구간을 span으로 묶고, 줄바꿈이 필요할 때는 `display: block;` 을 적용한다

```html
<div>
  <p>화면이 좁을 때는 줄바꿈이 일어나고 <br class="mobile-break-br" />넓을 때는 줄바꿈이 없습니다.</p>
  <p>
    <span class="mobile-break-span">화면이 좁을 때는 줄바꿈이 일어나고 </span>
    <span class="mobile-break-span">넓을 때는 줄바꿈이 없습니다.</span>
  </p>
</div>
```

```css
.mobile-break-span { 
  display: block;
}

@media screen and (min-width: 600px)  {
  .mobile-break-br { 
    display: none;
  }
  
  .mobile-break-span { 
    display: inline;
  }
}
```

![](fig/responsive_line_breaks.png)

# 참고자료

- [Stackoverflow | Line break on mobile phone only](https://stackoverflow.com/a/52662634)
- [Responsive Line Breaks](http://v3.danielmall.com/articles/responsive-line-breaks/)
