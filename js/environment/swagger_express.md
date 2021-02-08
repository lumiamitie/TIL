# Node express를 위한 swagger 세팅하기

다음과 같이 express와 swagger 관련 라이브러리를 설치한다.

```bash
npm install express swagger-jsdoc swagger-ui-express
```

다음과 같이 `server.js` 를 구성한다.

```javascript
const express = require('express')
const app = express()
const port = 8888

// MiddleWares : Builtin Body-Parser
app.use(express.json())

// MiddleWares : CORS
app.use(function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*')
    res.header('Access-Control-Allow-Methods', 'GET')
    res.header('Access-Control-Allow-Headers', "Origin, X-Requested-With, Content-Type, Accept")
    next()
})

app.use('/docs', require('./api/swagger'))

app.listen(port, function() {
    console.log(`Listening on port: ${port}`)
})
```

이제 다음과 같이 `api/swagger.js` 파일을 생성한다.

```javascript
const express = require('express')
const router = express.Router()
const swaggerJsdoc = require('swagger-jsdoc')
const swaggerUi = require('swagger-ui-express')

const options = {
    swaggerDefinition: {
      openapi: "3.0.0",
      info: {
        title: "Test API",
        version: "0.1.0",
        description: "Description for API"
      },
      servers: [
        {
          url: "http://localhost:8888"
        }
      ]
    },
    apis: ['./api/*.js']
}

const specs = swaggerJsdoc(options)
router.use('/', swaggerUi.serve)
router.get('/', swaggerUi.setup(specs))

module.exports = router;
```

다음과 같이 Express 서버 어플리케이션을 실행시키면 `localhost:8888/docs` 주소를 통해 스웨거 페이지에 진입할 수 있다.

```bash
node server.js
```

# 참고자료

- [Documenting your Express API with Swagger](https://blog.logrocket.com/documenting-your-express-api-with-swagger/)
- [Swagger: Time to document that Express API you built!](https://levelup.gitconnected.com/swagger-time-to-document-that-express-api-you-built-9b8faaeae563)
