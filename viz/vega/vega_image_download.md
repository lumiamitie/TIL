# Vega 이미지 다운로드

공식문서 [링크](https://github.com/vega/vega-view#view_toImageURL)를 참고하여 진행했다 

a태그 따로 만들지 않는 버전 (원본)

```javascript
// generate a PNG snapshot and then download the image
view.toImageURL('png', 1).then(function(url) {
  var link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('target', '_blank');
  link.setAttribute('download', 'vega-export.png');

  // 크롬의 경우 이렇게 하면 자동으로 클릭이벤트가 발생해서 다운로드가 된다
  // 사파리는 안됨!!
  link.dispatchEvent(new MouseEvent('click'));
}).catch(function(error) { /* error handling */ });
```

사파리에서는 자동 다운로드가 동작하지 않았다
따라서 a 태그를 직접 만들고 클릭을 통해 다운로드 받을 수 있도록 수정함

```html
<!-- HTML에서 다음 내용 추가 -->
<a id="download">Download</a>
```

```javascript
view.toImageURL('png', 8).then(url => {
  var link = document.querySelector('#download');
  link.setAttribute('href', url);
  link.setAttribute('target', '_blank');
  link.setAttribute('download', 'vega-export.png');

  // 이 부분 활성화시키면 페이지 열리면서 자동으로 다운로드 (사파리에선 안되는 것 같다)
  // link.dispatchEvent(new MouseEvent('click'));
})
```

`view.toImageURL('png', 3)` 에서 두 번째 인자는 **scale factor** 이다. 해당 수치를 조절하여 이미지 사이즈를 변경할 수 있다!!
