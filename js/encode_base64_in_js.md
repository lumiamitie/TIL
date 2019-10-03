# 문자열을 base64로 인코딩하기

문자열을 base64로 인코딩하려면 어떻게 해야 할까?

- Node에서는 Buffer를 사용한다
- 참고. <https://icodealot.com/convert-data-to-base64-in-nodejs/>
    - 문서에는 `new Buffer` 를 사용해 변환하는데, deprecated 되었다고 한다
    - `Buffer.from` 을 사용하는 것을 권장

```javascript
Buffer.from('문자열').toString('base64')
```

- 브라우저에서는 btoa 함수를 쓰면 된다고 한다
    - <https://stackoverflow.com/a/26514148>
