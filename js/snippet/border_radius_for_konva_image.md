# Konva 이미지 노드에 border-radius 적용하기

## 문제상황

- Konva에서 `Konva.Image.fromURL` 함수를 사용해 이미지를 불러온 뒤 각 모서리를 둥글게 하고자 한다
- Konva에서 제공하는 이미지 노드의 attribute 에는 해당 기능이 없는 것 같은데 어떻게 하면 될까?

## 해결방법

- 빈 Group 객체를 생성한다
- 생성한 Group의 `clipFunc` 프로퍼티에 둥근 모서리 형태를 Path로 직접 그리는 함수를 만들어 적용한다
- 해당 그룹에 이미지 노드를 추가하면 된다

```javascript
let stage = new Konva.Stage({
    container: 'container', // Node에서는 이 부분 제거
    width: 360,
    height: 80
});

let layer = new Konva.Layer();
stage.add(layer);

// 이미지에 border-radius를 적용하기 위한 Clipping Function
// * 아래 함수를 Group 오브젝트의 clipFunc 프로퍼티를 통해 전달한다
const calcClipFunc = function (ctx, x, y, width, height, radius) {
    ctx.beginPath();
    ctx.moveTo(x + radius, y);
    ctx.lineTo(x + width - radius, y);
    ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
    ctx.lineTo(x + width, y + height - radius);
    ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    ctx.lineTo(x + radius, y + height);
    ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
    ctx.lineTo(x, y + radius);
    ctx.quadraticCurveTo(x, y, x + radius, y);
    ctx.closePath();
};

Konva.Image.fromURL('https://url.to.image', function (imgNode) {
    let imgWidth = imgNode.width();
    let imgHeight = imgNode.width();
    let imgRadius = 6;
    // 이미지에 border-radius 를 적용하기 위해 Clipping용 Group을 생성한다
    let imgClip = new Konva.Group({
        x: 0,
        y: 0,
        clipFunc: ctx => calcClipFunc(ctx, 0, 0, imgWidth, imgHeight, imgRadius)
    });
    // 이미지를 레이어에 추가한다
    imgNode.setAttrs({
        x: 0,
        y: 0,
        width: imgWidth,
        height: imgHeight,
    });
    imgClip.add(imgNode)
    layer.add(imgClip);
    // 렌더링한다
    layer.draw();
});
```

# 참고자료

- [StackOverflow | How to add border-radius to react-konva Image object?](https://stackoverflow.com/a/59473573)
