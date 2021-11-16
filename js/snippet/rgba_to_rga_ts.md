# RGBa 색상을 RGB로 변경하기

Figma 플러그인을 만들기 위해 고민하던 내용을 정리. Figma 플러그인이 타입스크립트를 사용하기 때문에 TS로 작성.

```typescript
// 피그마에서는 각 r,g,b 값을 0~1 사이의 값으로 사용한다.
interface Color {
  r: number,
  g: number,
  b: number
}

function hexToRGB(hex: string): Color {
  const trimmedHex: string = hex.trim().replace('#', '')
  const hexColor: string[] = trimmedHex.length === 3 ? trimmedHex.match(/.{1}/g).map(c => c+c) : trimmedHex.match(/.{2}/g)
  const numberedColor: number[] = hexColor.map(c => parseInt(c, 16)/255)

  return {
    r: numberedColor[0],
    g: numberedColor[1],
    b: numberedColor[2],
  }
}

function blendOpacityToColor(color: Color, alpha: number): Color {
  // https://stackoverflow.com/a/2049362
  // 배경 색상과 대상 색상에 대해 alpha 값에 비례한 가중 평균을 구하는 느낌..
  // (아래에 *1 은 흰색과 대상색을 섞는다고 가정해서 1을 곱한다. 흰색이 아닌 다른 색일 경우 해당 색상의 r,g,b 값을 사용한다.
  return {
    r: (1-alpha) * 1 + (alpha * color.r),
    g: (1-alpha) * 1 + (alpha * color.g),
    b: (1-alpha) * 1 + (alpha * color.b),
  }
}

const baseColorHex: string = '#cccccc';
const baseColor = hexToRGB(baseColorHex);
const blendedColor = blendOpacityToColor(baseColor, 0.8);
// {r: 0.8400000000000001, g: 0.8400000000000001, b: 0.8400000000000001}
// rgb(244, 244, 244) 라고 해야겠다.
```

# 참고자료

- [StackOverflow : Convert RGBA color to RGB](https://stackoverflow.com/a/2049362)
- [StackOverflow : Convert RGBA to RGB taking background into consideration](https://stackoverflow.com/questions/11614940/convert-rgba-to-rgb-taking-background-into-consideration)
