# vue-router 에서 페이지 이동할 때 스크롤 초기화하기

## 문제상황

* 스크롤을 내린 상태에서 라우터를 통해 다른 페이지로 이동할 경우, 스크롤이 초기화되지 않고 내려가있는 상태로 옮겨간다
* GNB 영역이 맨 위에 있었을 때는 문제가 없었는데 화면 상단에 고정시켜두니 이런 문제가 발생..

## 해결방법

* router 객체에 scrollBehavior 함수를 추가한다
    * [vue-router 공식문서의 Scroll-Behavior 페이지](https://router.vuejs.org/kr/guide/advanced/scroll-behavior.html)
* 코드를 아래와 같이 수정한다

```javascript
// 수정전 (src/main.js) ////////////////////////
const router = new VueRouter({
    routes
});

// 수정후 (src/main.js) ////////////////////////
const router = new VueRouter({
    routes,
    scrollBehavior (to, from, savedPosition) {
        return { x: 0, y: 0 }
    }
});
```
