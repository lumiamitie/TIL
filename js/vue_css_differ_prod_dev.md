# 웹팩 빌드 후 CSS가 다르게 적용되는 문제

## 문제상황

- 웹팩 dev 서버에서 hot reloading을 통해 페이지를 띄울 경우에는 문제가 없는데, 빌드 후 확인해보면 CSS가 의도한 대로 반영되지 않는 이슈가 중간중간 발견되었다
- 확인해 본 결과 빌드 후에는 CSS가 적용되는 순서가 달라져서 우선순위가 바뀌는 바람에 화면에서 보이는 방식이 달라지고 있었다

## 원인

- 원인
    - 웹팩 dev 서버에서 실행시킬 때는 css를 읽어서 style-loader를 통해 head 태그에 직접 임베딩한다
    - 반면에 빌드를 하게되면 css들을 추출해서 하나의 파일로 구성한다
    - css 파일을 구성하는 과정에서 css가 적용되는 순서가 바뀌고, 이로 인해 우선순위가 변동되는 케이스가 발생한다
- 참고
    - 비슷한 문제: <https://stackoverflow.com/questions/53565484/vuetify-css-change-order-during-webpack-build>
    - <https://stackoverflow.com/questions/43628609/how-do-i-correct-the-css-compile-order-with-webpack-in-vuejs>
    - SFC style ordering : <https://github.com/vuejs/vue-loader/issues/808>
    - CSS Output Order Differs between Production and Dev : <https://github.com/vuejs-templates/webpack/issues/815>
    - CSS 동작이 달라지는 원인 : <https://github.com/vuejs/vue-loader/issues/808#issuecomment-348608911>

## 해결방법

다음 방법 이외에 추가적인 해결 방법이 존재하는지는 확인이 필요하다.

1. css를 모듈 단위로 관리하지 말고 단일 css 파일을 구성해서 직접 순서를 관리한다
2. css를 우선순위에 맞게 수정한다...

### Before

```vue
<v-flex>
    <v-subheader class="align-start">{{ value.label }}</v-subheader>
</v-flex>
```

### After

```vue
<v-flex>
    <v-subheader class="aa-label-to-top">{{ value.label }}</v-subheader>
</v-flex>

// 우선 순위를 유지시키기 위해 새롭게 CSS를 적용한다
<style>
.aa-simpleform .v-subheader.aa-label-to-top {
    -webkit-box-align: start;
    -ms-flex-align: start;
    align-items: flex-start;
}
</style>
```
