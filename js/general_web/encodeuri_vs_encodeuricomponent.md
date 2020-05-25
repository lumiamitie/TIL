# encodeURI 와 encodeURIComponent 의 차이점

- `encodeURI` : URI에 대해 특별한 의미 (예약 문자)를 갖는 문자들은 인코딩하지 않는다
- `encodeURIComponent` : 모든 문자를 인코딩한다

```javascript
encodeURI("!*'();:@&=+$,/?#")
// !*'();:@&=+$,/?#

encodeURIComponent("!*'();:@&=+$,/?#")
// !*'()%3B%3A%40%26%3D%2B%24%2C%2F%3F%23

////

encodeURI('aa@1234,(bb&5678)#?')
// aa@1234,(bb&5678)#?

encodeURIComponent('aa@1234,(bb&5678)#?')
// aa%401234%2C(bb%265678)%23%3F

decodeURI('aa%401234%2C(bb%265678)%23%3F')
// aa%401234%2C(bb%265678)%23%3F

decodeURIComponent('aa%401234%2C(bb%265678)%23%3F')
// aa@1234,(bb&5678)#?
```

# 참고자료

- [What is the difference between decodeURIComponent and decodeURI?](https://stackoverflow.com/questions/747641/what-is-the-difference-between-decodeuricomponent-and-decodeuri)
- [GET 방식으로 query string 넘길 때 특수문자 사라짐 현상](https://steady-snail.tistory.com/111)
- [MDN | encodeURIComponent()](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)
- [MDN | encodeURI()](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/encodeURI)
