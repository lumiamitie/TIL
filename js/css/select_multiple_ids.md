# 하나의 CSS Selector로 여러 개의 id 선택하기

## 목표

`#sec01`, `#sec02`, `#sec03` 등 여러 개의 DOM id 를 CSS Selector 한 번으로 전부 선택할 수 있을까?

## 해결방법

### 1) 여러 CSS Selector 를 comma 로 나열한다

- 장점 : 특정한 패턴이 없어도 쓸 수 있다
- 단점 : 원하는 항목을 다 적어야 한다

```javascript
document.querySelectorAll('#sec01,#sec02')
// NodeList(2) [section#sec01, section#sec02]
```

### 2) Attribute Selector [id*= ""] 를 사용한다

- 장점 : 패턴만 맞으면 한 번에 다 잡는다
- 단점 : 특정한 패턴이 있어야 한다

```javascript
document.querySelectorAll('section[id*="sec"]')
// NodeList(5) [section#sec01, section#sec02, section#sec03, section#sec04, section#sec05]
```

# 참고자료

- [How to access two Ids in one css selector](https://stackoverflow.com/questions/9902305/how-to-access-two-ids-in-one-css-selector)
- [MDN : 특성 선택자](https://developer.mozilla.org/ko/docs/Web/CSS/Attribute_selectors)
