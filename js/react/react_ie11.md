# React IE11 대응하기

## CASE1 : IE11에서 리액트로 작성한 페이지가 돌아가도록 대응해보자

- `react-app-polyfill` 라이브러리를 추가한다
- [https://www.npmjs.com/package/react-app-polyfill](https://www.npmjs.com/package/react-app-polyfill)

```bash
npm install react-app-polyfill
```

- `src/index.js` 맨 윗줄에 다음 코드를 추가한다

```jsx
// src/index.js 맨 윗줄에 추가한다
import 'react-app-polyfill/ie11';
import 'react-app-polyfill/stable';
```

- `package.json` 에서 browserslist 를 수정한다

```json
"browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "ie 11", // ie 11 을 추가한다
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
}
```

- 변경사항이 제대로 반영되지 않을 경우, `node_modules/.cache` 디렉토리를 삭제한 뒤에 다시 시도해본다

## 참고자료

- [CRA(create-react-app)에서 IE 지원하기](http://www.chidoo.me/index.php/2020/02/27/create-react-app-ie-support/)
- [[Develop/React] React ie지원 설정하기](https://hoons-up.tistory.com/13)
