# gatsby `gatsby-plugin-mdx` 플러그인과 함게 mathjax 사용하기

- `gatsby-remark-katex` 로 시도했는데 잘 동작하지 않았음.
- `remarkMath` 와 `rehypeKatex` 로 해결했다.
- [Github : gatsby issues 28031](https://github.com/gatsbyjs/gatsby/issues/28031#issuecomment-908771286)

```bash
yarn add katex@0.13.16 remark-math@3.0.1 rehype-katex@5.0.0
```

`gatsby-plugin-mdx` 플러그인의 옵션으로 `remark-math` 와 `rehype-katex` 를 등록한다.

```jsx
// gatsby-config.js
// 

const plugins = [
    // ...
    {
      resolve: 'gatsby-plugin-mdx',
      options: {
        // ...
        remarkPlugins: [require('remark-slug'), require(`remark-math`)],
        rehypePlugins: [require(`rehype-katex`)],
      }
    },
// ...
```

관련 Github Issue : <https://github.com/gatsbyjs/gatsby/issues/21866>

참고로, 그냥 사용하면 블록 단위 수식이 길어질 때 레이아웃이 깨지는 경우가 발생한다. 컨텐츠가 넘칠 때 자동으로 스크롤 처리되도록 CSS를 수정한다.

```css
div.math {
    overflow-x: auto;
}
```
