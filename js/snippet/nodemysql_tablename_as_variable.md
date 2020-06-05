# Node-Mysql2 쿼리에서 테이블 이름을 변수로 처리하기

- 쿼리의 조건문에 임의의 값을 채워넣을 때, `?` 등의 문자를 통해 값을 대체하는 경우가 많다
- 만약 바꿔야 하는 값이 테이블명이라면 어떻게 처리할 수 있을까?

# Answer

- 테이블 이름이 들어갈 위치에 `??` 로 표기하고, `.format` 함수를 통해 쿼리를 생성한다

```javascript
const mysql = require('mysql2/promise');

(async function() {
  const connection = await mysql.createConnection({
    host: host, 
    user: user, 
    password: password,
  });
  let query = mysql.format('SELECT * FROM ?? LIMIT ?', ['table.user', 10]);
  // 'SELECT * FROM `table`.`user` LIMIT 10'
  const [rows, fields] = await connection.execute(query);
  await conn.end();
})()
```

# 참고자료

- [Stackoverflow | Nodejs-Mysql Query table name as a variable](https://stackoverflow.com/a/45422771)
- [Github mysqljs/mysql | Preparing Queries](https://github.com/mysqljs/mysql#preparing-queries)
- [sidorares/node-mysql2 | Prepared Statements](https://github.com/sidorares/node-mysql2/blob/master/documentation/Prepared-Statements.md)
