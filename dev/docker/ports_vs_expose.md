# ports vs expose

- `expose` 로 포트를 노출하면 호스트 내부의 다른 컨테이너들만 액세스할 수 있습니다.
- `ports` 로 노출하면 설정한 호스트 포트번호를 통해 호스트 외부의 다른 호스트들도 액세스할 수 있습니다.

## CASE 1

- node 컨테이터 → MySQL 접근 가능 (3307)
- 외부 호스트 → MySQL 접근 가능 (3307)

```yaml
db: 
  image: mysql:latest 
  ports: 
    - "3307:3306" 
node: 
  image: node:latest
```

## CASE 2

- node 컨테이터 → MySQL 접근 가능 (3306)
- 외부 호스트 → MySQL 접근 불가

```yaml
db: 
  image: mysql:latest 
  expose: 
    - "3306"
node: 
  image: node:latest
```

[[Docker] ports와 expose의 차이](https://growd.tistory.com/77)
