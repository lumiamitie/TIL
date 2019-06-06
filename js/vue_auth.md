# Vue 앱에서 인증 구현하기

유데미 **Vue JS 2 - The Complete Guide** 강의 Section 23를 듣고 정리
(*Authentication in Vue Apps*)

## 345. Module Introduction

- **인증(Authentication)** 은 대부분의 웹 어플리케이션에서 중요한 역할을 차지한다
  - 주로 백엔드 쪽에서 중요한 작업들이 이루어지기 때문에, 사실 Vue와는 크게 관련이 없다
  - 여기서는 서버쪽 작업 대신 token을 사용해 프론트에서 인증 절차를 추가하는 방법에 대해서 알아보려고 한다
  - 토큰을 어떻게 저장하고 관리하는지, vuex와는 어떻게 통합하는지, 원하지 않는 라우팅을 어떻게 막아야 하는지 등등을 살펴보자
  - 데모 백엔드로는 firebase를 사용하지만 어떤 백엔드 구성에서도 적용할 수 있는 내용들이다

## 346. How Authentication Works in SPAs

- Single Page Application이 아니었다면 서버에서 세션을 관리하는 방식으로 인증을 처리할 것이다
- **SPA 에서는 인증이 어떻게 동작할까?**
  - (1) 여전히 Server가 있고, 브라우저에서 SPA가 동작한다
  - (2) 유저가 로그인하거나 회원가입을 하면, 서버로 데이터를 전송한다
  - (3) 서버에서는 DB를 통해 유저와 비밀번호를 조회하고 정보가 맞다면 무엇인가를 반환해준다
    - 전통적인 웹에서는 이것이 바로 **세션** 이었다
    - SPA에서는 상태가 없는 RESTful API를 사용하기 때문에 연결 여부를 신경쓰지 않아도 되고, 따라서 세션을 관리하지 않는다
    - 따라서 세션 대신에 **토큰** 을 반환한다
    - 토큰은 js 오브젝트로 디코드될 수 있는 굉장히 긴 문자열 값이며 서버에 저장되어 있다
      - 유저의 정보와 언제 파기되는지 등이 기록되어 있다
      - 토큰이 정말 서버를 통해서 생성되었는지를 검증할 수 있다
      - 제한된 시간 동안에만 유효하다
  - (4) 반환된 토큰을 브라우저에 저장한다
    - 예를 들면 Local Strorage API를 통해 로컬 스토리지에 저장할 수 있다
  - (5) 이후에는 정보를 요청할 때 Request와 함께 토큰을 첨부하여 보낸다


## 347. Project Setup

- 여기서는 백엔드 로직에 집중하지 않기 위해 firebase를 사용할 것이다
- firebase에서는 Authentication 탭에 가면 인증 관련 설정을 할 수 있다
  - **SET UP SIGN-IN-METHOD** (한글 페이지에서는 **로그인 방법 설정**) 를 클릭한다
  - **Email/Password** (이메일/비밀번호) 를 선택하여 사용하도록 설정한다
  - 이제 Database 메뉴의 Rules 탭에 들어가서 인증된 사용자만 READ 가능하도록 설정한다
    - Before : `".read": true`
    - After : `".read": "auth != null"`
    - 수정 후 Publish(게시) 버튼을 누른다
  - 이제 다시 웹에서 콘솔을 보면 401 (Unauthorized) 에러가 발생하는 것을 볼 수 있다
  - firebase SDK를 통해 인증할 수도 있지만, 여기서는 어떤 백엔드에서도 적용할 수 있도록 RESTful API를 사용하는 방법을 살펴보려고 한다
    - firebase는 사용자 등록이나 로그인을 위한 REST API 엔드포인트를 제공한다
    - [Firebase Auth REST API](https://firebase.google.com/docs/reference/rest/auth/?hl=ko)


## 348. Adding User Signup

- Firebase에서 제공하는 API를 통해 신규 유저를 생성하는 방법을 알아보자
  - API 엔드포인트는 다음과 같다
  - `https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=[API_KEY]`
- `axios-auth.js` 파일에서 custom axios 인스턴스를 생성할 때 baseURL을 변경해보자
  - `baseURL: 'https://www.googleapis.com/identitytoolkit/v3/relyingparty'`
- `signup.vue` 에서는 기존의 `/user.json` 대신 `/signupNewUser` 로 요청하도록 한다
  - 요청을 위해 필요한 API KEY는 firebase 계정에서 찾을 수 있다
  - Authentication 페이지에서 우측 상단에 있는 **WEB SETUP** (웹 설정) 버튼을 누른다
  - 화면에 뜨는 정보에서 *apiKey* 를 복사한다
  - 해당 엔드포인트가 요구하는 데이터를 오브젝트로 구성한다
- 이제 어플리케이션으로 돌아오자
  - Sign Up 페이지에 가서 사용하지 않았던 이메일을 입력한다
  - Firebase 에서 비밀번호는 여섯 자리 이상이어야 한다
  - `axios_auth.js` 에서 커스텀 헤더를 설정하면 에러가 발생할 수 있다. 제거하고 실행해보자
    - `main.js` 에서 `axios.defaults` 로 설정할 경우, axios 모듈 전역으로 사용된다
    - 따라서 main.js에 존재하는 defaults 설정도 확인해야 한다
  - Submit 해보면 정상적으로 요청되는 것을 볼 수 있다
    - response를 살펴보면 토큰을 하나 추가로 받은 것을 볼 수 있는데, 이것은 Refresh Token으로 `idToken`을 갱신하는데 사용된다
    - `expiresIn` 항목을 보면 얼마동안 토큰이 유효한지 초 단위로 알 수 있다. 3600으로 되어 있으니 한 시간 동안 유효하다.
  - Firebase의 Authentication 페이지에 가보면 사용자로 추가된 것을 확인할 수 있다
    - user UID 값은 자동적으로 생성된다

```javascript
// src/axios_auth.js ////
import axios from 'axios'

// 사용자 추가를 위한 엔드포인트를 baseURL로 등록한다
const instance = axios.create({
  baseURL: 'https://www.googleapis.com/identitytoolkit/v3/relyingparty'
})

// 커스텀 헤더 설정은 제거한다
// instance.defaults.headers.common['SOMETHING'] = 'something'

export default instance
```

```javascript
// src/components/auth/signup.vue ////
......
axios.post('/signupNewUser?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
  	    email: formData.email,
        password: formData.password,
        returnSecureToken: true
	})
    .then(res => console.log(res))
    .catch(error => console.log(error))
......
```



## 349. Adding User Signin (Login)

- 이번에는 로그인 하는 방법을 알아보자
- `signin.vue` 컴포넌트로 가서 form을 전송하면 로그인이 되도록 만들어보자
  - `axios_auth.js` 로부터 axios 인스턴스를 임포트한다
  - 로그인을 위해서는 다음 엔드포인트를 사용한다
    - `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=[API_KEY]`
    - signup과 동일한 baseURL에, `/verifyPassword` 엔드포인트를 사용한다
  - 회원가입과 동일하게 `axios.post` 에 필요한 정보들을 포함시켜서 요청을 보낸다
  - 이제 Sign In 페이지에 가서 테스트해보자
    - 정상적으로 요청이 이루어지는 것을 확인할 수 있다
    - 이번에도 idToken과 refreshToken이 함께 반환되었다
- 이제 해야 할 일은 인증을 위해 사용할 수 있도록 어딘가에 토큰을 저장하는 것이다
  - 지금과 같은 상태에서는 요청시에 토큰을 함께 보내지 않기 때문에 대시보드 페이지에 들어가면 여전히 에러가 발생하고 있다

```vue
<!-- src/components/auth/signin.vue -->
......
<script>
  import axios from '../../axios_auth'

  export default {
    data () {
      return {
        email: '',
        password: ''
      }
    },
    methods: {
      onSubmit () {
        const formData = {
          email: this.email,
          password: this.password,
        }
        console.log(formData)

        axios.post('/verifyPassword?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
          email: formData.email,
          password: formData.password,
          returnSecureToken: true
        })
          .then(res => console.log(res))
          .catch(error => console.log(error))
      }
    }
  }
</script>
......
```



## 350. Using Vuex to send Auth Requests

- 이제 인증을 통해 받은 토큰을 vuex store에 저장해야 한다
- 그 전에 **회원가입 및 로그인 로직을 store로 옮겨보자**
  - `src/store.js` 에서 작업한다
  - Store의 state 프로퍼티에 `idToken`, `userId`를 추가한다 (기본값은 `null`)
- 이제 actions에 회원가입, 로그인 액션을 추가해보자
  - `signup({commit}, authData)`
  - `login({commit}, authData)`
- 이제 컴포넌트에 직접 정의되어 있는 axios 코드들을 action으로 옮겨온다
  - 변수명을 함수에 맞게 변경한다 (`formData` -> `authData`)
- 이제 `signup.vue` , `login.vue` 로 돌아와서, `onSubmit()` 메소드에 액션을 디스패치한다
  - `this.$store.dispatch('action_name', data)`
- 토큰을 저장하는 방법을 알아보기 전에, 이렇게 바꾼 로직이 제대로 동작하는지 살펴보자

```javascript
// src/store.js ////
import Vue from 'vue'
import Vuex from 'vuex'
import axios from './axios_auth';

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    idToken: null,
    userId: null
  },
  mutations: {

  },
  actions: {
    signup({commit}, authData) {
      axios.post('/signupNewUser?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
          email: authData.email,
          password: authData.password,
          returnSecureToken: true
        })
        .then(res => console.log(res))
        .catch(error => console.log(error))
    },
    login({commit}, authData) {
      axios.post('/verifyPassword?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
          email: authData.email,
          password: authData.password,
          returnSecureToken: true
        })
        .then(res => console.log(res))
        .catch(error => console.log(error))
    }
  },
  getters: {

  }
})
```

```vue
<!-- src/components/auth/signup.vue -->

<script>
	// 이제 axios를 불러올 필요가 없으니 제거한다
    // import axios from '../../axios_auth';
...
  methods: {
    ...
    onSubmit () {
        const formData = {
          email: this.email,
          age: this.age,
          password: this.password,
          confirmPassword: this.confirmPassword,
          country: this.country,
          hobbies: this.hobbyInputs.map(hobby => hobby.value),
          terms: this.terms
        }
        console.log(formData)

        // 불필요한 코드는 제거한다
        // axios.post('/signupNewUser?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
        //   email: formData.email,
        //   password: formData.password,
        //   returnSecureToken: true
        // })
        //     .then(res => console.log(res))
        //     .catch(error => console.log(error))

        // 동일한 로직을 vuex action을 통해 구현한다
        this.$store.dispatch('signup', {
          email: formData.email,
          password: formData.password
        })
    }

...
</script>
```

```vue
<!-- src/components/auth/signin.vue -->

<script>
	// 이제 axios를 불러올 필요가 없으니 제거한다
    // import axios from '../../axios_auth';
...
  methods: {
    ...
    onSubmit () {
        const formData = {
          email: this.email,
          password: this.password,
        }
        console.log(formData)
        // 불필요한 코드는 제거
        // axios.post('/verifyPassword?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
        //   email: formData.email,
        //   password: formData.password,
        //   returnSecureToken: true
        // })
        //   .then(res => console.log(res))
        //   .catch(error => console.log(error))

        // Vuex Action을 통해 동일한 로직을 구현한다
        this.$store.dispatch('login', {
          email: formData.email,
          password: formData.password
        })
    }

...
</script>
```



## 351. Storing Auth Data in Vuex

- mutation을 추가해보자
  - `authUser (state, userData)`
  - 여기서 토큰과 userID를 state에 추가한다
- 생성한 mutation을 각 action의 promise 안에서 동작하도록 한다
  - `.then(res => commit('authUser', userData))`
- 이제 회원가입 또는 로그인을 할 때마다 state를 통해 token이 저장된다

```javascript
// src/store.js ////

import Vue from 'vue'
import Vuex from 'vuex'
import axios from './axios_auth';

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    idToken: null,
    userId: null
  },
  mutations: {
    // authUser Mutation을 추가
    authUser(state, userData) {        //
      state.idToken = userData.token   //
      state.userId = userData.userId   //
    }                                  //
  },
  actions: {
    signup({commit}, authData) {
      axios.post('/signupNewUser?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
          email: authData.email,
          password: authData.password,
          returnSecureToken: true
        })
        .then(res => {
          console.log(res)

          // Mutation을 커밋한다
          commit('authUser', {        //
            token: res.data.idToken,  //
            userId: res.data.localId  //
          })                          //

        })
        .catch(error => console.log(error))
    },
    login({commit}, authData) {
      axios.post('/verifyPassword?key=AAAAAAAAAAAAAAAAAA-ccccccccccccccccccc', {
          email: authData.email,
          password: authData.password,
          returnSecureToken: true
        })
        .then(res => {
          console.log(res)

          // Mutation을 커밋한다
          commit('authUser', {        //
            token: res.data.idToken,  //
            userId: res.data.localId  //
          })                          //

        })
        .catch(error => console.log(error))
    }
  },
  getters: {

  }
})
```

## 353. Accessing other Resources from Vuex

이제 store에 저장한 토큰을 사용해보자. `dashboard.vue` 컴포넌트의 GET 요청을 보내려면 토큰이 필요하다.

- 우선 기존의 GET 요청을 store의 action으로 보낸다
    - `fetchUser({commit})` 액션을 만든다
    - 해당 액션안으로 기존의 axios 요청을 옮겨야 하는데 몇 가지 주의사항이 있다
        - store.js 에서 임포트한 axios 인스턴스는 데이터를 가져오기 위한 것이 아니다
        - 또 사용자 정보를 가져오고 싶은데, 지금은 회원가입을 하더라도 firebase에 데이터를 저장하는 것이 아니라 사용자 인증만 시켜두고 정보는 다른 데이터베이스에 저장한다
- 따라서 **토큰을 가져오기 전에 두 가지 해야 할 일이 있다**
    - 첫 번째는 회원가입을 할 때 then 블록이 완료되면, 또 다른 action을 dispatch해서 유저 정보를 firebase에 저장하는 것이다
        - 인증을 위한 데이터베이스 말고 데이터 저장을 위한 데이터베이스에 저장하기 위해서다
        - 왜냐면 Firebase Authentication Database에는 우리가 접근할 수 없기 때문
    - 두 번째는 Firebase 인증체계 바깥에서 데이터를 저장하거나 가지고 오기 위한 baseURL을 구성하는 것이다
- store.js 에서 axios를 새로 임포트하고 globalAxios 라고 이름붙여보자
    - 이 인스턴스가 유저 데이터를 저장하고 받아오기 위한 것이다
    - `storeUser({commit}, userData)` 액션을 추가한다
        - 여기서 globalAxios 인스턴스를 통해 POST 요청을 보낸다
        - globalAxios 인스턴스는 main.js에서 정의한 디폴트 baseURL의 영향을 받는다
        - 따라서 그냥 `globalAxios.post('/users.json', userData)` 을 사용한다
    - storeUser 액션은 데이터를 받을 때 수행되어야 한다
        - 액션의 인자로 사용되는 context 객체는 dispatch 메서드를 가지고 있다
        - signup 액션을 다시 정의해보자
            `- signup({commit, dispatch}, authData) { ... }`
            - 이제 회원가입이 발생할 때 storeUser 액션을 dispatch 하는 작업까지 포함한다
                - `dispatch('storeuser', authData)`
    - fetchUser 에서 사용한 axios도 globalAxios로 변경한다
        - 그리고 then 블록 안에서 `commit('storeUser', users[0])` 을 통해 데이터를 저장한다

이제 테스트해보기 전에, 데이터베이스의 Rules로 돌아가서 인증받은 사용자만 write 가능하도록 수정한다.

- Before : `".write": true`
- After : `".write": "auth != null"`
- 데이터를 보내는 시점에는 (storeUser) 사용자가 인증되어 있을 것이기 때문이다

여기서는 Mutation을 통해 데이터를 저장하고 있다.
따라서 `storeUser(state, user)` mutation을 생성하고 여기서 받은 user를 `state.user` 에 저장한다.
이제 마지막으로 getter 를 추가한다. `user(state) { return state.user }`

- dashboard.vue 에서 데이터를 가져오는 작업을 해보자
    - computed 프로퍼티를 생성하고 getter를 통해 데이터를 가져온다
        - `email() { return this.$store.getters.user.email }`
    - created 훅에서는 fetchUser 액션을 dispatch 한다
        - `this.$store.dispatch('fetchUser')`

하지만 그래도 unauthorized 에러가 발생한다.. 요청을 보낼 때 토큰을 함께 보내지 않았기 때문이다!

## 354. Sending the Token to the Backend

현재는 토큰을 받아서 store에만 넣어두고, firebase database로 http 요청을 보낼 때 함께 보내지는 않고 있다. 이것을 개선해보자.

- 토큰을 통해 보내는 것은 기본적으로 엄청나게 간단하다
    - storeUser 에서 context 객체를 가져올 때 현재 state도 함께 가져온다
    - state는 우리가 토큰을 저장할 곳을 말한다
    - state.idToken 값이 존재하지 않으면 (null), globalAxios 객체를 이용한 요청을 하지 않게끔 한다
    - 그 외의 경우에는 토큰이 존재하기 때문에, 백엔드에서 요구하는 조치를 취한다
        - 어떤 백엔드에서는 인증을 위한 헤더를 추가해야 할 수 있다
        - Firebase의 경우 auth 라는 추가 파라미터를 url에 추가해야 한다
        - '/users.json?auth=' + state.idToken 형태가 된다
    - storeUser 이외에 다른 요청도 동일하게 수정한다 (fetchUser)
    - 중요한 것은 store의 state 로부터 정보를 추출해서 요청을 보낼 때 추가한다는 점이다

## 355. Protecting Routes (Auth Guard)

이번에는 인증되지 않았을 때 dashboard에 접근하지 못하도록 설정해보자.
기능을 추가하기 위해 라우팅 섹션에서 다루었던 Navigation Guard를 사용한다.

- 특정한 route로 접근하는 것을 막기 위해, route.js 에서 beforeEnter 프로퍼티를 설정한다
    - beforeEnter 프로퍼티는 3개의 인자를 가지는 메서드이다
        - to : 어디로 향하는지에 대한 정보
        - from : 어디서 왔는지에 대한 정보
        - next : navigating을 진행하기 위한 함수
    - 함수 안에서 사용자가 토큰을 가지고 있는지 여부를 확인한다
        - 이 정보를 확인하기 위해 store.js 를 임포트한다
        - 토큰이 존재할 경우 next() 를 실행시킨다
        - 없으면 next('/signin') 메서드를 통해 로그인 페이지로 리다이렉트시킨다

## 356. Updating the UI State (based on Authentication State)

이번에는 인증받지 않은 경우 아예 링크가 보이지 않게끔 해보자.

- `header.vue` 에서 링크가 인증 상태에 따라 변하게 설정해야 한다
    - 우선, store.js 에 새로운 getter isAuthenticated 를 만든다
    - isAuthenticated 는 state를 받아서 state.idToken 이 null인지 여부를 반환한다
- `header.vue` 에서 getter를 사용할 수 있도록 컴포넌트를 설정한다
    - computed 프로퍼티에 auth 를 생성하고, `this.$store.getters.isAuthenticated` 를 반환한다
    - 링크에 v-if 를 적용하여 auth 의 조건에 따라 표시여부를 결정하도록 한다
- 이제 인증 상태에 따라 UI를 업데이트 할 수 있게되었다!

## 357. Adding User Logout

유저가 직접 로그아웃할 수 있도록 링크를 추가해보자. 로그아웃 버튼과 메서드를 추가하고 이벤트리스너에 등록해야 한다.

- 로그아웃 메서드에서는 token과 user id값을 제거하는 액션을 디스패치해야 한다
    - clearAuthData mutation을 생성해서 idToken과 userId를 null로 바꾸도록 한다
    - logout action을 생성하고, 이 안에서 clearAuthData 를 커밋한다
- header.vue 로 돌아와서, onLogout() 메서드에서 logout 액션을 디스패치한다
    - 그리고 인증되었을 때만 로그아웃 버튼이 보이도록 v-if 로 상태를 체크 해준다
- 이번에는 로그아웃 하면 다른 페이지로 이동하도록 해보자
    - store.js 에서 router를 임포트한다
    - logout 액션 안에서 커밋 후에 페이지를 이동하도록 한다
    - router.replace('/signin')

- 현재 우리가 만들고 있는 앱의 한 가지 단점은 리프레스할 때마다 인증이 초기화된다는 것이다.
    - 사용자가 불편함을 느끼지 않도록 세션을 유지시키면 좋겠다
- 또한 파이어베이스에서 보내주는 토큰은 한 시간 동안만 유효하다
      - 따라서 한 시간이 지나면 자동으로 로그아웃 시키는 로직도 필요하다

## 358. Adding Auto Logout

유저가 한 시간 이상 앱에 머물러 토큰이 만료된 경우, 자동으로 로그아웃 시키는 기능을 추가해보자.

- 한 가지 중요한 것은 파이어베이스가 요청 때마다 리프레시 토큰을 발급해준다는 것이다
    - ID token과는 다르게 이 값은 만료되지 않는다
    - 리프레시 토큰을 특정 url 엔드포인트로 보내면 새로운 ID 토큰을 발급받을 수 있다
    - [Firebase REST docs : Exchange custom token for an ID and refresh token](https://firebase.google.com/docs/reference/rest/auth/?hl=ko#section-verify-custom-token)
    - 따라서 이러한 방식을 사용하면 끊기지 않고 지속되는 세션을 구현할 수 있다
- 리프레시 토큰을 이용하게 될 경우 보안상으로는 덜 안전하다
    - 리프레시 토큰은 만료되지 않기 때문이다
    - 따라서 누구든지 리프레시 토큰을 확보하게 될 경우, 새로운 ID 토큰을 생성할 수 있다
    - 제3자가 리프레시 토큰을 가져가기 어렵게 하기 위해서 로컬스토리지에 저장한다
    - 이렇게 하면 cross-site scripting attack을 통해서만 접근할 수 있는데, 이건 기본적으로 vue에서 막고 있다
    - 따라서 덜 안전하지만, 위험한 수준은 아니라고 볼 수 있다
    - 여기서는 리프레시 토큰을 이용하는 방법을 구현하지 않는다
- 인증이 만료된 유저를 어떻게 하면 자동으로 로그아웃 시킬 수 있을까?
    - **시간에 따라 자동으로 액션을 디스패치시킬 수 있는 타이머가 필요하다**
    - setLogoutTimer 액션을 추가한다
        - context 객체로부터는 commit 인자를 받고, 추가로 expiration time을 받는다
        - setTimeout 함수를 사용해서 타이머를 만든다
        - expirationTime * 1000 만큼의 시간이 지나면 logout 액션을 커밋한다
            - 1000을 곱하면서 자동으로 문자열이 real number로 변환된다
    - setLogoutTimer 액션을 login, signup 액션 내부에서 디스패치한다
        - `dispatch('setLogoutTimer', res.data.expiresIn)`

## 359. Adding Auto Login

- 이번에는 리프레시 하더라도 로그인이 유지되게끔 수정해보자
- 이렇게 하기 위해서는 토큰을 vuex store가 아닌 다른 곳에 저장해두어야 한다
    - 브라우저가 제공하는 localStorage API를 사용하여 구현할 수 있다
        - `localStorage.setItem('key', value)`
    - 토큰, 유저 id, 만료시점을 로컬 스토리지에 저장해둔다
        - expiresIn보다는 만료되는 시점을 저장하는 것이 더 좋은 방식이다
        - `new Date()` 를 통해 현재 시점의 시간을 구하고, expiresIn을 더한다
            - `new Date(now.getTime() + res.data.expiresIn * 1000)`
            - 밀리세컨드 단위의 만료시점 시간을 구하고 Date로 변환한다
- 로컬스토리지에 저장한 값을 크롬 개발자도구에서 확인해보자
    - Application > Storage > Local Storage > app의 URL을 선택한다
- 이제 저장한 값을 꺼내오는 방법에 대해 알아보자
    - 어플리케이션이 시작할 때 로컬스토리지에 접근하여 토큰 등 값을 가져와야 한다
    - 일단 store.js 에 `tryAutoLogin()` 이라는 새로운 액션을 생성한다
        - 로컬스토리지에 접근하여 저장해둔 값이 있으면 가져온다
        - `localStorage.getItem('token')`
    - 가져온 토큰값을 확인해야한다
        - 토큰이 없거나 false 값이면 아무런 값 없이 그냥 리턴해버린다
        - 토큰이 있다면 expirationDate 도 가져와서 토큰이 아직 유효한지 확인한다
        - 토큰이 유효할 경우 로그인을 시도한다 (authUser mutation을 커밋한다 )
    - app.vue 파일의 created() 훅 내부에서 tryAutoLogin 액션을 디스패치한다
- 한 가지 문제는 로그아웃하더라도 로컬 스토리지를 정리하지 않는다는 점이다
    - logout 액션에서 로컬스토리지의 모든 값을 제거하자
    - `localStorage.clear()` 를 쓰면 모든 값을 제거할 수 있지만, 다른 항목들도 있어서 모든 값을 제거하면 안될 수도 있다
    - `localStorage.removeItem()` 으로 각각 제거한다
    - 이제 로그아웃하면서 로컬스토리지의 값들이 제거된다
