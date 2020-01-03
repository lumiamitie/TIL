# ssh 포트가 22가 아닐 때 rsync 사용하기

## 문제상황

- rsync를 통해 로컬에서 다른 서버로 데이터를 전송하고자 한다
- ssh 포트로 22가 아니라 다른 포트를 쓰고 있을 때는 어떻게 해야 할까?

## 해결방법

- `-e` 옵션에 `'ssh -p <port>'` 를 추가한다

```bash
rsync -avzh -e 'ssh -p 10022' /home/miika/data/ deploy@example.com:/home/deploy/data
```

# 참고자료

[rsync 사용법 - data backup 포함](https://www.lesstif.com/pages/viewpage.action?pageId=12943658#rsync사용법-databackup포함-ssh가22가아닐경우연결)
