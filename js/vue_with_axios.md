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
