# React에서 반응형 이미지 적용하기

- React에서 다양한 디바이스에 대응하기 위해 이미지를 반응형으로 제공하려면 어떻게 해야할까?

## Answer 1

- 다음과 같이 picture 태그와 srcset 프로퍼티를 통해 적용할 수 있었다

```jsx
import React from "react";

import IconSmall1x from "../images/small.png";
import IconMedium2x from "../images/medium.png";
import IconLarge3x from "../images/large.png";

const ResponsiveImage = ({}) => {
  return (
    <picture>
      <source srcSet={IconSmall1x} media={"(max-width: 400px)"}></source>
      <source srcSet={IconMedium2x} media={"(max-width: 800px)"}></source>
      <source srcSet={IconLarge3x} media={"(min-width: 801px)"}></source>
      <img src={IconSmall1x}></img>
    </picture>
  );
};

export default ResponsiveImage;
```

## 주의할 점

- 리액트 컴포넌트 내에서 사용할 때는 `srcset` 프로퍼티를 `srcSet` 으로 사용해야 한다
    - <https://reactjs.org/docs/dom-elements.html#all-supported-html-attributes>
- `picture` 태그 안에 `img` 태그가 꼭 필요하다
    - 이미지가 차지하는 영역, 그리고 어떻게 표현되어야 하는지 정보를 제공한다
    - 기본값 및 picture 태그를 지원하지 않는 브라우저에 대한 대체 이미지 역할을 한다

# 참고 자료

## Responsive Images

- [MDN | 반응형 이미지](https://developer.mozilla.org/ko/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)
- [Google Developers Web | 이미지](https://developers.google.com/web/fundamentals/design-and-ux/responsive/images?hl=ko)

## 적용 방법

- [반응형 이미지 제대로 사용해보자!](https://velog.io/@jerrynim_/반응형-이미지-제대로-사용하기)
- [A guide to Responsive images with srcset - Ultimate Courses™](https://ultimatecourses.com/blog/a-guide-to-responsive-images-with-srcset)
- [How to Build Responsive Images with srcset - SitePoint](https://www.sitepoint.com/how-to-build-responsive-images-with-srcset/)

## React 관련

- [Why is React.js removing the srcset tag on?](https://stackoverflow.com/questions/34695899/why-is-react-js-removing-the-srcset-tag-on-img)
- [stereobooster/react-ideal-image](https://github.com/stereobooster/react-ideal-image/blob/master/introduction.md)
