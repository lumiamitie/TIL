# Callback 함수를 Promise로 변경하기

## Using util.promisify

- 먄약 변환하려는 콜백 함수가 Node의 Error-First Callback 패턴을 따른다면 쉽게 Promise로 변환할 수 있다.
- 다음과 같은 콜백 함수를 살펴보자

```javascript
const fs = require('fs');

// Error-First Callback (Node Style)
fs.readFile('sample.json', (err, data) => {
    if (err) {
        console.error(err);
        return;
    } else {
        console.log(JSON.parse(data));
    };
});
```

- `util.promisify`를 사용하면 Error-First Callback 을 Promise로 변환할 수 있다
- 위 코드를 Promise로 변환하면 다음과 같다

```javascript
const util = require('util');
const readFilePromise = util.promisify(fs.readFile);

readFilePromise('sample.json')
    .then(data => console.log(JSON.parse(data)))
    .catch(err => console.error(err));
```

## Writing your own Promise

- Error-First Callback 패턴을 따르지 않는 경우라면 어떻게 해야 할까
- 이 경우에는 직접 Promise를 작성해서 사용해야 한다
- Node에서 `mysql2` 라이브러리를 통해 컨넥션을 생성하고 쿼리를 보내는 코드를 Promise로 작성해보자
    - (사실 mysql2에서는 promise API를 제공한다)
    - [mysql2 Documentation : Promise-Wrapper](https://github.com/sidorares/node-mysql2/blob/master/documentation/Promise-Wrapper.md)

### Connection with Callback

기존 코드는 다음과 같은 형태로 되어 있다.

```javascript
// 공통 코드 (mysql2 로드 및 설정 객체 생성)
const mysql = require('mysql2');
const config = {
    "host": "localhost",
    "user": "username",
    "password": "password",
    "database": "database"
};

// Callback 버전
const connection = mysql.createConnection(config);
connection.query('SELECT * from db.table LIMIT 100', function(err, results, fields) {
    if (err) {
        console.error(err);
        return;
    };
    console.log(results);
});
```

### Connection with Promise

- Promise는 then 메서드에서 Promise를 반환하여 여러 단계의 작업을 연결할 수 있다
- 따라서 첫 번째 then 메서드에서 다음과 같은 작업을 통해 체이닝이 가능하게끔 한다
    - `connWrapper` 객체를 생성한다
    - `connWrapper.query` 메서드는 기존 mysql2의 `.query` 메서드의 결과를 프로미스를 통해 전달한다
    - 이후 단계에서 컨넥션을 닫을 수 있어야 하기 때문에 resolve 를 통해 다음 단계로 connection과 query promise를 넘긴다
- 다음과 같이 promise 기반의 함수로 변경할 수 있다

```javascript
// MySQL 컨넥션 객체를 Promise로 감싸는 함수를 작성한다
let connectPromise = function(config) {
    return new Promise((resolve, reject) => {
        let connection = mysql.createConnection(config);
        connection.on('error', (err) => reject(err));

        let connWrapper = {
            conn: connection,
            query: function(query) {
                return new Promise((resolve, reject) => {
                    connection.query(query, function(err, results) {
                        if (err) return reject(err);
                        resolve({
                            conn: connection,
                            results: results
                        });
                    });
                });
            }
        };
        resolve(connWrapper);
    });
};

// Promise 버전
connectPromise(config)
    .then(conn => conn.query('SELECT * from db.table LIMIT 100'))
    .then(d => {
        console.log(d.results);
        d.conn.end();
    })
    .catch(err => {
        console.error(err);
    });
```

# 참고자료

- [Zell Liew: Converting callbacks to promises](https://zellwk.com/blog/converting-callbacks-to-promises/)
- [Promises chaining](https://javascript.info/promise-chaining)
- [MDN: Using promises](https://developer.mozilla.org/ko/docs/Web/JavaScript/Guide/Using_promises)
