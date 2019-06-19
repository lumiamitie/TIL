# v-for 문에서 Custom Elements 사용할 때 key 없다는 에러 해결하기

## 문제상황

- Vue CLI3의 `npm run build` 를 실행한 결과 다음과 같은 에러가 발생했다
    - `Custom elements in iteration require 'v-bind:key' directives`
- 컴파일이 실패할 정도의 에러는 아니었지만, 거슬리니까 해결해보기로 한다

```
Module Warning (from ./node_modules/eslint-loader/index.js):
error: Custom elements in iteration require 'v-bind:key' directives (vue/valid-v-for)
  10 | <v-list>
  11 |     <template v-for="(item, index) in subvalues">
> 12 |         <v-list-tile>
     |         ^
  13 |             <v-list-tile-content>
  14 |                 {{ item.title }}

error: Custom elements in iteration require 'v-bind:key' directives (vue/valid-v-for)
  20 |                 </v-list-tile-content>
  21 |             </v-list-tile>
> 22 |             <v-divider></v-divider>
     |             ^
  23 |         </template>
  24 |     </v-list>
  25 | </v-card>
```

## 해결과정

 [참고 : 'v-for' directives require 'v-bind:key' directives Issue](https://mkki.github.io/vue.js/eslint/2018/05/14/vujs-eslint-issue.html)

### 1차 시도

- template 태그에 key값을 추가해보았다
    - `<template>` 태그는 key 처리가 될 수 없다는 에러가 발생했다

```vue
<template v-for="(item, index) in subvalues" :key="index">
    <v-list-tile>
        <v-list-tile-content>
            {{ item.title }}
        </v-list-tile-content>
        <v-list-tile-content>
            {{ item.value }}
        </v-list-tile-content>
    </v-list-tile>
    <v-divider></v-divider>
</template>
```

```
Failed to compile.
Errors compiling template:
<template> cannot be keyed. Place the key on real elements instead.

9  | <v-divider></v-divider>
10 | <v-list dense>
11 |     <template v-for="(item, index) in subvalues" :key="index">
   |                                                  ^^^^^^^^^^^^
```

### 2차 시도

- `<v-list-tile>` 과 `<v-divider>` 태그에 index값으로 key를 부여했다
- 다음과 같은 경고가 발생했다
    - `[Vue warn]: Duplicate keys detected: '0'. This may cause an update error.`

```vue
<template v-for="(item, index) in subvalues">
    <v-list-tile :key="index">
        <v-list-tile-content>
            {{ item.title }}
        </v-list-tile-content>
        <v-list-tile-content>
            {{ item.value }}
        </v-list-tile-content>
    </v-list-tile>
    <v-divider :key="index"></v-divider>
</template>
```

### 3차 시도 (해결!)

- `v-list-tile` 에는 `index + 'l'` 로, `v-divider` 에는 `index + 'r'` 로 key를 부여해서 중복되지 않게끔 했다

```vue
<template v-for="(item, index) in subvalues">
    <v-list-tile :key="index +'l'">
        <v-list-tile-content>
            {{ item.title }}
        </v-list-tile-content>
        <v-list-tile-content>
            {{ item.value }}
        </v-list-tile-content>
    </v-list-tile>
    <v-divider :key="index +'r'"></v-divider>
</template>
```
