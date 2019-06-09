# Vue CLI 3

유데미 **Vue JS 2 - The Complete Guide** 강의 Section 25를 듣고 정리.

## Module Introduction

- Big Picture
  - vue create : 새로운 vue 프로젝트를 생성한다 (이전 버전에서는 vue init)
    - Use Preset
    - Custom Config : 각종 플러그인을 선택하여 시작할 수 있다
  - Develop & Build
  - vue add @vue/pluin-name : 플러그인 추가

## Creating a Project

- `npm install -g @vue/cli` 명령어로 vue cli 3을 설치한다
  - 기존 버전은 vue-cli 라는 이름으로 되어있다
  - 설치하게 되면 기존에 존재하던 vue 바이너리를 덮어씌우기 때문에, vue init 명령어를 사용할 수 없게 된다
- vue create <project-name> 으로 새로운 프로젝트를 생성한다
- 그러면 프리셋을 선택할 수 있다
  - 기본값은 babel, eslint 로 되어 있고
  - 미리 설정해 둔 커스텀 프리셋이 있다면 여기서 함께 선택할 수 있다
  - Manually select features 를 눌러서 커스텀으로 설정할 수 있다
- Manually select features를 선택하면 방향키와 스페이스를 이용해서 필요한 기능을 추가할 수 있다
  - Babel
  - TypeScript
  - PWA
  - Router
  - Vuex
  - CSS pre-processors
  - Linter / Formatter
  - Unit Testing
  - E2E Testing
  - 추가 설정이 필요한 기능의 경우 세부적인 옵션을 선택해야 한다
- 사용자 폴더에 가면 .vuerc 라는 파일이 생성된 것을 볼 수 있다
  - vue cli에 대한 글로벌 설정이 담겨있는 파일이다
  - 모든 프리셋에 대한 정보도 파일 안에 담겨있다
  - 프리셋을 지우고 싶다면, 파일에 있는 프리셋 정보를 제거하면 된다
- 설치가 완료되었다면 npm run serve 명령어로 개발용 서버를 띄워볼 수 있다

## Analyzing the Created Project

- `package.json`
  - scripts : npm run 명령어로 실행시킬 수 있는 명령어들이 정의되어 있다
  - dependencies : 웹팩에서 설정되지 않은 디펜던시들이 있다
    - 웹팩과 관련된 다양한 설정들은 @vue/cli-service 밑에있다
  - browserslist : 어느 브라우저를 지원할지를 설정한다
    - babel, autoprefixer 등 일부 플러그인에서 중요하다
- public 폴더
  - Single Page App이라면 index.html 파일이 존재하는 곳이다
  - PWA에서는 `manifesto.json` 이 존재한다
    - 브라우저가 인식할 수 있도록 앱에 대한 메타 정보를 저장해둔 파일이다
  - static asset 들이 위치할 수 있다
    - public 폴더에 있는 asset들을 사용하면 최적화 없이 앱에 복사하여 사용하게 된다
    - 반면에 js에서 임포트되거나 template/css 를 통해 상대경로로 접근한 asset들은 웹팩에 의해서 제어된다
- src 폴더
  - 우리가 작성하는 코드가 위치하는 곳이다

## Using Plugins

- 프로젝트를 생성한 다음에도 플러그인을 추가할 수 있다
- 사용할 수 있는 플러그인에는 어떤 것들이 있을까?
  - 모든 플러그인들은 특정한 네이밍 패턴을 따른다 : `vue-cli-plugin-<plugin-name>`
  - 공식 플러그인들은 다음과 같은 패턴을 따른다 : `@vue/cli-plugin-<plugin-name>`
- vuetify 플러그인을 추가해보자
  - vue-cli-plugin-vuetify 라는 이름으로 플러그인이 존재하는 것을 확인할 수 있다
  - 커맨드 라인 명령어 `vue add vuetify` 를 입력하면 설치할 수 있다
    - 네이밍 패턴에서 플러그인 이름에 해당하는 부분만 입력하면 된다
  - 설치가 완료되면 기존 프로젝트의 설정 중 일부가 변경된다
- 플러그인이 아닌 라이브러리는 `npm install --save` 명령어를 통해 설치한다
  - `npm install --save axios`

## CSS Pre-Processors

- Sass 같은 CSS 전처리기를 어떻게 추가할 수 있을까?
- `<style>` 태그에 `lang="scss"` 옵션을 추가하면 문법상 에러는 표시되지 않지만 컴파일 과정에서 에러가 발생한다
  - sass-loader 가 없다는 에러가 발생했다
  - 이 부분은 cli plugin 을 통해 해결할 수 없기 때문에 따로 설치해주어야 한다
  - `npm install --save sass-loader node-sass`
- 라이브러리가 잘 설치되었다면 자동으로 반영된다
- Stylus 나 Less 같은 다른 전처리기도 비슷한 방식으로 추가할 수 있으니 공식 문서를 참고할 것



## Environment Variables

- 큰 어플리케이션을 만들다보면 환경 변수를 설정해야 하는 경우가 생긴다
  - 환경 변수란 외부에서 어플리케이션으로 주입할 수 있는 전역 변수를 말한다
  - 예를 들면, 개발환경과 배포 환경에 따라 달라질 수 있는 URL이나 API
  - vue cli 에서 어떻게 처리할 수 있는지 살펴보자
- Vue cli 에서 다룰 수 있는 환경 변수 파일을 생성해보자
  - 프로젝트 폴더에 .env 라는 이름의 파일을 생성하고 다음 내용을 추가한다
    - `VUE_APP_URL=https://dev.api.com`
  - 그러면 vue 컴포넌트에서는 process.env.VUE_APP.URL 로 접근할 수 있다
    - 템플릿에서 사용하기 위해서는 data 프로퍼티에 등록해야 한다

```
// .env
VUE_APP_URL=https://dev.api.com
```

```
<!-- src/views/Home.vue -->
<template>
  <p>{{ url }}</p>
</template>

<script>
export default {
  data() {
    return {
      url: process.env.VUE_APP.URL
    }
  }
}
</script>
```

- 개발용과 배포용 url을 구분하기 위해서는 어떻게 해야 할까?
  - 개발용 환경파일 `.env.development` 를 프로젝트 폴더에 생성한다
  - 두 파일의 내용을 다음과 같이 수정한다
    - .env : `VUE_APP_URL=https://api.com`
    - .env.development : `VUE_APP_URL=https://dev.api.com`
    - .env 대신 .env.production 으로 설정해도 동일하다
  - `npm run build` 로 프로덕션 빌드를 하게 되면 .env 가 반영되고,
  - `npm run serve` 로 개발용 빌드를 하게 되면 .env.development 가 반영된다
- 주의! : 환경 변수의 이름은 VUE_APP_ 으로 시작해야 한다

## Building the Project

- build 명령어는 컴파일한 코드를 번들로 묶고, serve 명령어는 코드를 메모리상에 띄워두고 개발용 서버와 디버깅을 위한 도구들을 제공한다
  - 해당 명령어들은 `package.json` 파일에 정의되어 있다
  - 프로젝트를 생성할 때 자동으로 설치된 vue-cli-service 패키지를 바탕으로 동작한다
- package.json 안에 새로운 명령어를 정의할 수도 있다
  - `"build:development": "vue-cli-service --mode development"`
  - --mode 를 직접 명시할 경우, 빌드 폴더에 dev mode의 결과물을 빌드할 수 있다
  - `npm run build:development` 로 실행한다
- 새로운 mode를 생성할 수도 있다 : staging 이라는 이름의 mode를 생성해보자
  - `.env.staging` 파일을 만든다
  - 그러면 이제 `vue-cli-service --mode staging` 도 동작한다

```
// package.json

{
  ...
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "lint": "vue-cli-service lint",
    "build:development": "vue-cli-service --mode development"
  },
  ...
}
```

## Instant Prototyping

- 지금은 vue-cli-service가 로컬 프로젝트에만 설치되어 있기 때문에 serve, build 명령어를 아무데서나 사용할 수는 없다
  - 하지만 vue-cli-service 를 전역으로 설치할 수도 있다
  - `npm install -g @vue/cli-service-global` 명령어로 설치한다
- 프로젝트에 속해 있지 않은 vue 파일을 실행해볼 수는 없을까?
  - vue-cli-service 에서 제공하는 Instant Prototyping 을 사용해보자
  - `@vue/cli-service-global` 이 설치된 상태에서 다음 명령어를 입력한다
  - `vue serve Hello.vue`

## Different Build Targets

- build 명령어를 사용하면 production 을 위해 빌드한다고 했다
  - 그렇다면 production을 위한 빌드라는 것은 어떤 것들을 말하는 걸까?
  - 세 가지 다른 build target(다시 말하자면 어플리케이션을 빌드하는 세 가지 방법)이 있다
- **Build Targets**
  1. **Vue App**
     - `vue build --target app or vue build`
     - Normal Vue App Bundle : Optimized + Minified + Code Splitting + ...
     - Vue 프레임워크와 프로젝트 코드를 모두 포함한다
  2. **Vue Library**
     - `vue build --target lib`
     - 다른 곳에서 사용할 수 있는 Vue 라이브러리 번들을 빌드한다
     - 프로젝트 코드만 포함한다 (Vue 프레임워크는 포함하지 않는다)
  3. **Web Component**
     - `vue build --target wc`
     - 배포할 수 있는 Web Component를 빌드한다
       - Vue 어플리케이션 밖에서도 이용할 수 있는 Custom HTML Element
       - Root Vue 인스턴스가 아니라 html 파일 안에 넣는다
       - 리액트나 앵귤러 또는 바닐라 js 프로젝트에서도 사용할 수 있다
     - 프로젝트 코드만 포함한다 (Vue 프레임워크는 포함하지 않는다)
     - vue를 임포트할 수 있는 모든 페이지에 적용할 수 있다

## Using the "Old" CLI Templates (vue init)

- vue init 을 그냥 사용하면 동작하지 않는다
  - 이전 버전의 cli를 사용하고 싶다면 어떻게 해야 할까?
- `npm install -g @vue/cli-init` 을 설치한다
- 이제 vue init 을 사용할 수 있다!

## Using the Graphical User Interface (GUI)

- `vue ui` 를 실행하면 브라우저에서 동작하는 프로젝트 매니저를 사용할 수 있다
