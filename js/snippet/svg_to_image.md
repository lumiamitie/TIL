# 웹페이지의 SVG 엘리먼트를 일반 이미지로 변환하기

- [Mermaid Live Editor](https://mermaid-js.github.io/mermaid-live-editor/) 에서 플로우 차트를 생성한 뒤에 이미지로 다운로드 받아보니 해상도가 너무 낮았다
- 화면에 보이는 SVG 엘리먼트를 고화질 이미지로 변환할 수 있을까?

```javascript
function svgToImage(svg, width, height, scaleRatio = 3) {
    // Canvas 엘리먼트를 생성한다
    let canvasNode = document.createElement('canvas')
    canvasNode.setAttribute('id', 'mk-canvas')

    // Canvas 이미지의 해상도를 높이기 위해 가로 세로 비율을 조정한다
    // http://blog.302chanwoo.com/2016/07/canvas/
    canvasNode.setAttribute('width', width*scaleRatio)
    canvasNode.setAttribute('height', height*scaleRatio)
    canvasNode.style.width = width + 'px'
    canvasNode.style.height = height + 'px'
    document.body.appendChild(canvasNode)

    // get svg data
    let xml = new XMLSerializer().serializeToString(svg);

    // make it base64
    // * btoa(xml) 를 그냥 사용하면 인코딩 에러가 발생한다
    // -> unescape, encodeURIComponent 로 감싸서 사용
    // -> https://stackoverflow.com/a/26603875
    let svg64 = btoa(unescape(encodeURIComponent(xml)));
    let b64Start = 'data:image/svg+xml;base64,';

    // prepend a "header"
    let image64 = b64Start + svg64;

    // set base64 string as the source of the img element
    let img = new Image(width*scaleRatio, height*scaleRatio)
    img.src = image64
    img.onload = function () {
        let ctx = canvasNode.getContext('2d')
        ctx.scale(scaleRatio, scaleRatio)

        // 투명 배경으로 놔두면 다크모드를 사용중인 어플리케이션에서 이미지가 잘 안보인다
        // 흰색으로 이미지 배경을 채워버린다
        ctx.fillStyle = "#FFFFFF"
        ctx.fillRect(0, 0, width*scaleRatio, height*scaleRatio)
        // 이미지를 Canvas에 붙여넣는다
        ctx.drawImage(img, 0, 0)
    }
}
```

이제 mermaid로 생성된 SVG 엘리먼트를 선택해서 이미지로 변환시켜보자.

1. svg 태그 중에서 id 값이 `"mermaid"` 라는 문자열을 포함하는 항목을 선택한다
2. 선택한 SVG의 너비값을 추출한다
3. 이미지로 변환!

```javascript
function getTargetSvg(svgElem = document.querySelector('svg[id*=mermaid]')) {
    let svgRect = svgElem.getBoundingClientRect()
    return {
        svg: svgElem,
        width: Math.ceil(svgRect.width),
        height: Math.ceil(svgRect.height)
    }
}

(function() {
    let { svg, width, height } = getTargetSvg()
    svgToImage(svg, width, height)
})()
```

# 참고자료

- [StackOverflow | Drawing an SVG file on a HTML5 canvas](https://stackoverflow.com/questions/3768565/drawing-an-svg-file-on-a-html5-canvas)
- [StackOverflow | Failed to execute 'btoa' on 'Window'](https://stackoverflow.com/a/26603875)
