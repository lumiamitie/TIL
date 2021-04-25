# Docker Anti Patterns

다음 글을 간단하게 정리해보자.

[Docker anti-patterns - Codefresh](https://codefresh.io/containers/docker-anti-patterns/)

도커의 나쁜 활용 사례

1. Docker 컨테이너를 가상머신 처럼 사용하는 것.
2. 투명성이 보장되지 않는 도커 이미지를 생성하는 것. (동일한 Dockerfile 을 가지고 있다면 동일한 이미지를 생성할 수 있어야 한다)
3. 외부에 부수효과를 일으키는 Dockerfiles을 작성하는 것.
4. 개발용 이미지와 배포용 이미지를 분리하지 않는 것.
5. 배포 환경마다 다른 이미지를 사용하는 것.
6. 도커 이미지를 배포 서버에서 빌드하는 것.
7. 도커 이미지 단위로 협업하지 않고 Git hash 단위로 협업하는 것.
8. 이미지 안에 Secret과 설정 값을 하드코딩하는 것. 
9. 온갖 CI/CD 작업을 Dockerfile 안에서 수행하는 것.
10. 컨테이너 내부에서 일어나는 패키징 작업을 명시적으로 작성하지 않는 것.
