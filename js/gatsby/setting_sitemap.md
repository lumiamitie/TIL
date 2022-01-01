# 사이트맵 세팅 및 구글 서치콘솔에 등록하기

다음 문서를 참고

<https://blog.wsgvet.com/gatsby-flexiblog-gatsby-config-and-rss-setting/>

- `gatsby-plugin-sitemap` 플러그인을 설치한다.

```bash
cd site
yarn add gatsby-plugin-sitemap
```

- `site/gatsby-config.js` 를 다음과 같이 수정한다.
    - `gatsby-plugin-sitemap` 를 위한 플러그인 옵션을 설정한다.
    - `siteMetadata.siteUrl` 항목을 추가해야 한다.

```jsx
// site/gatsby-config.js
module.exports = {
    plugins: [
      // ...
      {
        resolve: `gatsby-plugin-sitemap`,
        options: {
          output: `/sitemap`,
        }
      },
    ],
    // Customize your site metadata:
    siteMetadata: {
      // ...
      siteUrl: 'https://playinpap.github.io',
    }
}
```

사이트맵 대신 특정 URL만 별도로 색인 요청하기

<https://julynine2.tistory.com/entry/구글-서치-콘솔Google-Search-Console에서-색인-생성-요청하기>
