# MySQL 에서 NTILE 함수로 백분위 기준 그룹 나누기

- 특정한 변수를 기준으로 10분위 그룹을 나누려면 어떻게 해야 할까?
- SQL로는 NTILE 함수를 사용할 수 있으며, MySQL의 경우 8버전 이후부터 지원한다.

```
NTILE(n) OVER (
    PARTITION BY <expression>[{,<expression>...}]
    ORDER BY <expression> [ASC|DESC], [{,<expression>...}]
)
```

<https://www.mysqltutorial.org/mysql-window-functions/mysql-ntile-function/>
