# MySQL에서 숫자에 comma 포맷팅하기

MySQL 쿼리를 통해 숫자 정수 부분에 3자리마다 컴마로 자리수를 표기하려면 어떻게 해야 할까?

```
Example
---
12345    -> 12,345
12345.12 -> 12,345.12
```

`FORMAT` 함수를 사용하면 된다.

- `FORMAT(숫자, 소수점 자리수[, 로케일])`
    - 숫자 값을 `"#,###,###.##"` 형태의 문자열로 포맷팅한다
    - 주어진 소수점 자리수를 기준으로 반올림한다
    - 자리수가 0일 경우 정수 부분만 출력한다
    - 로케일을 명시하지 않을 경우 기본값은 `"en_US"` 이다

[MySQL Reference Manual : String Functions and Operators](https://dev.mysql.com/doc/refman/8.0/en/string-functions.html#function_format)

```sql
SELECT FORMAT(10000, 0);
-- 10,000

SELECT FORMAT(10000.123, 0);
-- 10,000

SELECT FORMAT(10000.123, 2);
-- 10,000.12

SELECT FORMAT(10000.456, 2);
-- 10,000.46
```
