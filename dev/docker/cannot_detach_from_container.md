# 도커 컨테이너에서 Ctr+p, Ctr+q 로 detach하지 못하는 문제

## 문제상황

- 도커 컨테이너에서 작업하다가 ctrl+p, ctrl+q 로 detach 하려고 했는데, 컨테이너가 종료되었다
- 컨테이너는 다음과 같은 형태의 명령어로 실행된 상태이다

```bash
docker-compose run --service-port --rm <svc_name> /bin/bash
```

## 해결방법

- 도커 컨테이너가 실행되었을 때 `-t` , `-i` 옵션이 모두 켜져있어야 `^p^q` 로 detach 할 수 있다고 한다
- docker-compose run 에는 tty 옵션은 있는데 interactive 모드 옵션은 없는 것 같다
- 따라서 docker exec 명령어를 통해 `-it` 옵션으로 컨테이너를 실행한다
- 여기서는 `^p^q` 로 컨테이너를 detach 하는 것이 가능해진다

```bash
docker exec -it <container_name> /bin/bash
```

# 참고자료

[Correct way to detach from a container without stopping it](https://stackoverflow.com/a/45985809)
[-i, -t 플래그의 의미](http://progressivecoder.com/run-docker-container-in-interactive-mode/)
