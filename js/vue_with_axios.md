# Vue에서 axios 사용하기

유데미 **Vue JS 2 - The Complete Guide** 강의 Section 22를 듣고 정리
(*Using Axios instead of vue-resource*)

## 333. Module Introduction

- **axios**는 javascript 어플리케이션에서 http 요청을 보내는데 사용되는 라이브러리이다
- Vue.js에 종속되지 않고 js 어플리케이션에서 일반적으로 많이 사용된다
- 이전에 다루었던 `vue-resource` 가 안전하지 않다거나, 사용하면 안된다는 것은 아니다

## 334. Project Setup

- 프로젝트 파일을 다운로드 받은 뒤, `npm install` 과 `npm run dev` 를 실행시킨다
- 회원가입, 로그인, 대시보드를 살펴볼 수 있는 화면을 확인할 수 있다
- 각각의 항목을 실제로 구현해 볼 것이다
- 백엔드로는 Firebase를 사용한다
  - (1) **프로젝트 추가**
    - 프로젝트 추가 버튼을 눌러서 신규 프로젝트를 추가한다
    - 프로젝트 이름을 입력하고 "계속" 버튼을 누른다
    - "프로젝트 만들기" 버튼을 누른다
  - (2) **Database 추가**
    - 개발 > Database > 데이터베이스 만들기
    - "Realtime Database"를 선택한다
    - Rule을 다음과 같이 수정하고 게시(publish)한다

```
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

## 335. Axios Setup

- Axios는 서드파티 패키지이기 때문에 Vue에 포함되어 있지 않다
  - Axios에 대해 자세히 알고 싶다면, axios 깃허브 레포지토리에 방문해보자
  - https://github.com/axios/axios
- 잠시 `npm run dev` 프로세스를 종료하고 다음 명령어로 Axios를 설치한다
  - `npm install --save axios`
  - 설치 후 다시 `npm run dev` 를 실행시킨다
- axios의 경우 vue-router 와는 달리  `Vue.use()` 를 사용할 필요가 없다
- 우리의 목표는 회원가입 페이지에서 데이터를 전송하고, 이 정보를 대시보드 페이지에서 받아오는 것이다

## 336. Sending a POST Request

- `signup.vue` 컴포넌트에서 axios를 임포트 한다
  - `import axios from 'axios';`
- `onSubmit()` 메소드에서 http 요청을 보내보자
  - Firebase에 데이터를 저장하기 위해 PUT 또는 POST 요청을 보낼 수 있다
  - 여기서는 `axios.post()` 를 통해 POST 요청을 보내보자
- `axios.post()` 는 최소한 두 개의 인자를 필요로 한다
  - 1) **URL** (string) : `https://<project-name>/firebaseio.com/users.json`
  - 2) **Data** (js object) : axios에서 자동으로 stringify 하여 전송한다
  - 3) **Additional Configuration for the Request** (js object, *optional*)
- 요청을 보내면 해당 post 메서드에 대한 프로미스를 반환한다
  - POST 요청을 보내는 것은 비동기 작업이기 때문에 작업이 완료되었을 때 수행되어야 하는 작업을 작성해야 한다 ( `.then()` )
  - arrow function을 이용해서 작업이 완료되었을 때 수행되어야 하는 기능을 구현한다
  - `.catch()` 블록을 이용하면 에러가 발생하는 경우를 포착하고 대응할 수 있다
    - 또는 그냥 로그를 남길 수도 있다
- Firebase의 설정이 잘 마무리되었는지 확인하고, 데이터를 전송해보자
  - Submit 버튼을 누르고 콘솔에서 로그를 확인해보면 잘 전송되었다는 것을 확인할 수 있다
  - axios에서 생성한 response 객체를 콘솔에서 볼 수 있다

```vue
<!-- src/components/auth/signup.vue -->
......
<script>
  import axios from 'axios';
    
  export default {
    data () {
      return {
        email: '',
        age: null,
        password: '',
        confirmPassword: '',
        country: 'usa',
        hobbyInputs: [],
        terms: false
      }
    },
    methods: {
      ......
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
          
        axios.post('https://<proj>.firebaseio.com/users.json', formData)
            .then(res => console.log(res))
            .catch(error => console.log(error))
      }
    }
  }
</script>
```

## 337. Sending a GET Request

- 이제 데이터를 받아오는 방법에 대해 알아보자
- `dashboard.vue` 컴포넌트에서 script 태그를 생성하고 `created()` 훅에서 데이터를 받아오도록 해보자
- 데이터를 받아올 때 사용할 `axios.get()` 은 한 개 이상의 인자를 필요로 한다
  - (1) URL (string)
  - (2) 요청을 위한 설정
- 이제 대시보드 페이지로 들어가보면 GET 요청이 완료되어 콘솔에 출력된 것을 확인할 수 있다
  - 반환된 오브젝트의 `data` 프로퍼티에 우리가 요청한 정보들이 담겨 있다

```vue
<!-- src/components/dashboard/dashboard.vue -->
<template>
    <div id="dashboard">
        <h1>That's the dashboard!</h1>
        <p>You should only get here if you're authenticated!</p>
    </div>
</template>

<script>
    import axios from 'axios';
    
    export default {
        created() {
            axios.get('https://vue-test-sc22.firebaseio.com/users.json')
                .then(res => console.log(res))
                .catch(error => console.log(error))
        }
    }
</script>
```

## 338. Accessing & Using Response Data

- 이제 받아온 데이터를 화면에 출력해보자
  - Vue 컴포넌트에 data 메소드를 추가하고 저장할 값들의 초기값을 지정한다
  - 이메일 값을 저장하면 `<p>` 태그 안에서 출력한다
- GET 요청을 통해 받아온 정보를 어떻게 저장할 수 있을까?
  - 비동기 작업이기 때문에 `.then()` 블록 안에서 데이터를 저장해야 한다
  - 우리가 원하는 데이터는 임의의 문자열로 구성된 key 안에 value 형태로 존재함
  - 반환된 오브젝트에 대해 for문을 통해 key를 순회하고, 데이터를 추출하여 배열에 밀어넣는다
- 이제 대시보드 페이지에 가보면 우리가 저장했던 이메일 값을 화면에서 확인할 수 있다

```vue
<!-- src/components/dashboard/dashboard.vue -->
<template>
  <div id="dashboard">
    <p>Your email address: {{ email }}</p>
  </div>
</template>

<script>
    import axios from 'axios';
    
    export default {
        data() {
            return {
                email: '' // 이메일 데이터 초기값
            }
        },
        created() {
            axios.get('https://vue-test-sc22.firebaseio.com/users.json')
                .then(res => {
                    console.log(res)
                    const data = res.data
                    const users = []
                    // 오브젝트를 순회하여 key값을 얻어내고
                    // 원하는 데이터만 배열에 다시 밀어넣는다
                    // 이 과정에서 key값은 id 프로퍼티에 추가함!
                    for(let key in data) {
                        const user = data[key]
                        user.id = key
                        users.push(user)
                    }
                    console.log(users)
                  // 이메일 값만 추출하여 데이터를 업데이트
                    this.email = users[0].email
                })
                .catch(error => console.log(error))
        }
    }
</script>
```

## 339. Setting a Global Request Configuration

- 지금은 컴포넌트 이곳저곳에서 동일한 baseURL을 사용하고 있다
  - baseURL 기본값을 정의하여 사용해보자
- **main.js** 에서 작업해보자
  - **컴포넌트가 동작하기 전 가장 먼저 실행되는 파일**이기 때문이다
  - axios를 임포트하고, `axios.defaults` 를 통해 글로벌 옵션을 조정한다
    - `axios.defaults.baseURL = 'https://<project>.firebaseio.com'`
- 이제 axios를 통해 요청하는 컴포넌트 에서는 baseURL 없이 요청하면 된다
  - `axios.post('/users.json', formData)`
  - `axios.get('/users.json')`
- main.js 에서 생성되는 axios 인스턴스를 모든 컴포넌트에서 공통적으로 사용한다
  - 따라서 다른 어떤 컴포넌트에서 axios를 사용하더라도 동일한 설정이 적용된다
- 글로벌 수준으로 옵션을 설정할 수도 있고, 요청별로 따로 설정하는 것도 가능하다
- 자주 설정하게 되는 것 중 하나는 **헤더에 대한 설정**이다
  - 헤더의 기본값을 설정하려면 `axios.defaults.headers` 를 통해 수정한다
  - `axios.defaults.headers.common` : 모든 요청에 공통적으로 적용될 헤더 설정
    - common 헤더에 `Authorization` 을 추가하면 백엔드로 토큰을 보내는데 사용할 수 있다
  - `axios.defaults.headers.get` : GET 요청에 적용될 헤더 설정

```javascript
// src/main.js ////

import Vue from 'vue'
import App from './App.vue'
import axios from 'axios' // Axios 임포트

import router from './router'
import store from './store'

// baseURL 기본값을 정의한다
axios.defaults.baseURL = 'https://<project>.firebaseio.com'
// 모든 요청에 추가할 헤더 설정
axios.defaults.headers.common['Authorization'] = 'something'
// GET 요청에 추가할 헤더 설정
axios.defaults.headers.get['Accepts'] = 'application/json'

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})
```

## 340. Using Interceptors

- **Interceptor** 는 요청을 보내기 직전이나 응답을 받은 직후에 항상 실행되어야 하는 기능을 함수로 정의해 둔 것을 말한다
- `axios.interceptors` 오브젝트를 통해 접근한다
  - 다음과 같이 `use()` 메소드를 통해 반영하고자하는 함수를 등록한다
  - `axios.interceptors.request.use(config => {})`
    - 함수는 configuration 오브젝트를 인자로 받는다
  - `axios.interceptors.response.use(res => {})`
    - Response 오브젝트를 인자로 받는다
- 이러한 기능은 app에 영향을 주지 않도록 주의해서 사용해야 한다
- **Interceptor를 제거**하려면 어떻게 해야할까?
  - `.eject()` 메소드를 사용한다
  - eject 하기 위해서는 interceptor의 id를 알고 있어야 한다
    - id 값은 use 메소드로 interceptor를 생성할 때 반환한다
    - 따라서 변수를 통해 id값을 저장하여 사용한다

```javascript
// src/main.js //////
import Vue from 'vue'
import App from './App.vue'
import axios from 'axios'

import router from './router'
import store from './store'

axios.defaults.baseURL = 'https://<project>.firebaseio.com'
axios.defaults.headers.common['Authorization'] = 'something'
axios.defaults.headers.get['Accepts'] = 'application/json'

// Request Interceptor
const reqInterceptor = axios.interceptors.request.use(config => {
    console.log('Request Interceptor', config)
    // 헤더를 변경하려면 headers 오브젝트를 변경한다
    config.headers.Authorization = 'something others'
    // 임의의 헤더를 새로 설정할 수 있다
    config.headers['SOMETHING'] = 'some value'
    return config
})

// Response Interceptor
const resInterceptor = axios.interceptors.response.use(res => {
    console.log('Response Interceptor', res)
    return res
})

// Request Interceptor를 제거한다
axios.interceptors.request.eject(reqInterceptor)
// Response Interceptor를 제거한다
axios.interceptors.response.eject(resInterceptor)

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})
```

## 341. Custom Axios Instances

- 지금까지는 axios 패키지로부터 글로벌 인스턴스를 생성하는 방식으로 사용했다
  - 모든 어플리케이션이 동일한 글로벌 설정을 공유한다면 이렇게 해도 상관 없다
  - 하지만 목표로 하는 URL이 다르고, 각각 다른 헤더 설정을 원한다면 어떻게 될까?
- **Custom Instance**를 통해 확장해보자
  - src 폴더 안에 `axios-auth.js` 파일을 새로 생성한다
    - axios를 임포트하고, 새로운 axios 인스턴스를 생성한다 ( `axios.create()`)
      - 여기에 baseURL, 헤더 등 설정을 추가할 수 있다
    - 설정이 끝나면 해당 인스턴스를 export 한다
  - 새로운 axixos 인스턴스가 필요한 곳에서 글로벌 axios 대신 임포트하면 된다

```javascript
// src/axios-auth.js ////
import axios from 'axios'

const instance = axios.create({
  baseURL: 'https://<newproject>.firebaseio.com'
})

instance.defaults.headers.common['SOMETHING'] = 'something'

export default instance
```

```vue
<!-- src/components/auth/signup.vue -->
...
<script>
    // 기존 //
    // import axios from 'axios';
    
    // Custom Instance 사용 //
    import axios from '../../axios_auth';
    
    ......
</script>
...
```

## 343. Useful Resources & Links

- Axios: <https://github.com/axios/axios>
