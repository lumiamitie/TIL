# gatsby 에 Google Analytics 세팅하기

[gatsby-plugin-google-gtag](https://www.gatsbyjs.com/plugins/gatsby-plugin-google-gtag/) 을 사용한다.

```bash
yarn add gatsby-plugin-google-gtag
```

`gatsby-config.js` 의 `plugins` 항목에 다음 내용을 추가.

```javascript
{
      resolve: `gatsby-plugin-google-gtag`,
      options: {
        // You can add multiple tracking ids and a pageview event will be fired for all of them.
        trackingIds: [
          '<tracking-id>'
        ],
        gtagConfig: {
          // optimize_id: "OPT_CONTAINER_ID",
          anonymize_ip: true,
          // cookie_expires: 0 으로 설정하면 값을 세션 쿠키로 저장해서 사용자수가 급증하는 결과물이 나타날 수 있다......
          // cookie_expires: 0,
        },
        // This object is used for configuration specific to this plugin
        pluginConfig: {
          // Puts tracking script in the head instead of the body
          head: false,
          // Setting this parameter is also optional
          respectDNT: true,
          // Avoids sending pageview hits from custom paths
          // exclude: ["/preview/**", "/do-not-track/me/too/"],
        },
      },
    },
```

- 참고.
    - `gatsby-plugin-google-gtag` 는 개발 서버 동작 중에는 작동하지 않는다.
    - gtag 발송을 테스트 해보고 싶다면, build 후 serve 명령어로 테스트한다.
        
```bash
gatsby build
gatsby serve
```
