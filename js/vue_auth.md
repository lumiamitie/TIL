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
