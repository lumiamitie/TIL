# global 설치 없이 npm 스크립트 실행하기

[No need for globals - using npm dependencies in npm scripts.](https://firstdoit.com/no-need-for-globals-using-npm-dependencies-in-npm-scripts-3dfb478908)

- 글로벌 설치를 통해 쉘 명령어처럼 사용할 수 있는 라이브러리들이 있음
    - 글로벌 설치 없이 사용할 수는 없을까..?
- npm install을 통해 라이브러리를 설치할 경우, 설치한 라이브러리의 모든 bin 폴더 내 스크립트가 한 군데 모인다
    - `./node_modules/.bin/` 위치에 심볼릭 링크가 모인다
    - 다음 예시를 통해 확인

```bash
#### npm global 설치시 ####
npm install -g mocha
mocha -V 
# 2.2.5

#### npm local 설치시 ####
npm install --save-dev mocha
./node_modules/.bin/mocha -V
# 2.2.5
```

## 참고

- npm 스크립트를 실행시킬 때, 자동으로 `./node_modules/.bin/` 을 PATH 환경변수에 추가한다
- 따라서 npm run 명령어를 통해 package.json 내 script 항목을 실행시킬 때는 위 주소를 입력하지 않아도 된다

```json
// package.json
{
    ...

    "scripts": {
        "test": "mocha -V"
    },

    ...
}
```
