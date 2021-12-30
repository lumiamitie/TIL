## ✅ Favicon 등록하기

- `gatsby-plugin-manifest` 을 설치한다.
    
```bash
cd site
yarn add gatsby-plugin-manifest
```
    
- `site/content/assets/favicon.png` 위치에 Favicon 이미지를 옮겨둔다.
- `site/gatsby-config.js` 에서 다음과 같이 세팅한다.

```jsx
// site/gatsby-config.js

module.exports = {
    // ...
    plugins: [
      {
        resolve: 'gatsby-plugin-manifest',
        options: {
          name: '블로그 이름입니다',
          short_name: '블로그 짧은 이름',
          icon: 'content/assets/favicon.png'
        }
      },
      // ...
    ],
    //..
}
```
