# docker-compose run 으로 컨테이너 내부의 스크립트 실행할 때 포트가 연결되지 않는 현상

## 문제상황

- `docker-compose.yaml` 파일에 컨테이너 내부/외부의 포트를 맵핑하여 사용하고 있었다
- 그런데 `docker-compose run` 명령을 통해 컨테이너 내부의 스크립트를 실행하니 포트 맵핑이 사라져서 컨테이너 바깥에서 내부로 요청을 전달할 수 없었다
- 무엇이 문제일까..?

## 해결방법

- 포트 충돌을 방지하기 위해 `docker-compose run` 명령은 기본적으로 포트 맵핑을 하지 않는다고 한다
- 설정해둔 포트를 사용하려면 `--service-ports` flag를 사용하면 된다

```
docker-compose run --service-ports --rm <service_name> bash /path/to/script.sh
```

# 참고자료

- [docker-compose run document](https://docs.docker.com/compose/reference/run/)
- [docker/compose Issue #1259 | Docker-compose run command doesnt map ports](https://github.com/docker/compose/issues/1259#issuecomment-90878095)
