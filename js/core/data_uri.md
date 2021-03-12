# Data URI Scheme

- 웹페이지에서 데이터를 인라인으로 포함시키기 위해 Data URI를 사용할 수 있다.
- 이미지나 스타일시트 등 보통 분리된 파일 형태로 사용하는 요소들을 한 번의 HTTP 요청으로 사용할 수 있다는 장점이 있다.
- 아래와 같은 구조로 되어 있다.
    - `data:` 로 시작하며, 실제 데이터는 `,` 이후에 등장한다

```
data:[<mediatype>][;base64],<data>
```

```html
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==" alt="Red dot" />
```

<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==" alt="Red dot" />

JS에서는 다음과 같이 사용할 수도 있다.

```javascript
let img = new Image();
img.addEventListener('load', () => {
    let ctx = document.querySelector('canvas').getContext('2d');
    ctx.drawImage(img, 0, 0);
});
img.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGElEQVQoU2NkYGD4z0AEYBxViC+UqB88AKk6CgERnGWPAAAAAElFTkSuQmCC"
```

# 참고자료

- [Base 64 간단 정리하기](https://pks2974.medium.com/base-64-간단-정리하기-da50fdfc49d2)
- [Wikipedia | Data URI scheme](https://en.wikipedia.org/wiki/Data_URI_scheme)
