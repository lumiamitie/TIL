# Node-MySQL2 promise API 에서 transaction 사용하기

- Node-MySQL2의 Promise API를 사용할 때 Connetion Pool 생성 후 트랜잭션을 적용하는 방법을 정리해보자

```javascript
const mysql = require('mysql2/promise');

// Connection Pool 생성
const pool = mysql.createPool({
    host: 'hostname',
    user: 'root',
    password: 'password'
});

// 컨넥션을 담을 빈 변수를 생성한다
let conn;

// 컨넥션을 만들고 작업을 수행한다
pool.getConnection()
    .then(connection => {
        conn = connection;
        // 트랜잭션을 시작한다
        return conn.beginTransaction();
    })
    .then(() => {
        // 임의의 작업을 수행한다
        let insertQuery = 'INSERT INTO db.table VALUES (?,?)';
        let data = ['Miika', 123];
        return conn.query(insertQuery, data);
    })
    // 작업이 완료되면 변경사항을 커밋하고 컨넥션을 pool에 반환한다
    .then(() => conn.commit())
    .then(() => conn.release())
    .catch(e => {
        // 작업이 실패하면 변경사항을 롤백한다
        conn.rollback();
        // 컨넥션을 pool에 반환한다
        conn.release();
        console.error(e);
    });
```

참고. <https://github.com/sidorares/node-mysql2/issues/554>
