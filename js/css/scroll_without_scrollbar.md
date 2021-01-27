# CSS로 스크롤바 없는 스크롤 구현하기

- `overflow: hidden;` 속성을 사용하면, 스크롤바가 사라지지만 스크롤 자체가 불가능해진다
- 스크롤은 가능하면서 스크롤바만 보이지 않게 할 수 있을까?

다음 CSS를 추가하면 스크롤바가 없지만 스크롤이 여전히 동작하는 것을 확인할 수 있다.

[How To Hide Scrollbars With CSS](https://www.w3schools.com/howto/howto_css_hide_scrollbars.asp)

```css
/* Hide scrollbar for Chrome, Safari and Opera */
.example::-webkit-scrollbar {
  display: none;
}

/* Hide scrollbar for IE, Edge and Firefox */
.example {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}
```

# 추가 자료

- [How to Hide Scrollbar and Visible Only Scrolling](https://medium.com/frontend-development-with-js/how-to-hide-scrollbar-and-visible-only-scrolling-79cc3472e503)
    - 스크롤할 때만 스크롤바 보이게 하기
- [SOLVED: Hide scrollbar but still scroll](https://vigu-madurai.medium.com/solved-hide-scrollbar-but-still-scroll-54955525d238)
    - 벤더 prefix CSS 없이 표준 CSS 만으로 스크롤바 없는 스크롤 구현하기
