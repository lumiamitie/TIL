# 사용하지 않는 docker 이미지 제거하기

- 도커 컨테이너를 바탕으로 작업을 계속하다 보면 사용하지 않는 이미지가 쌓이게 된다
- 사용하지 않는 도커 이미지를 한 번에 제거하기 위해 다음과 같은 명령을 사용할 수 있다

```bash
docker image prune -a
```

- [Docker Reference | docker image prune](https://docs.docker.com/engine/reference/commandline/image_prune/)
