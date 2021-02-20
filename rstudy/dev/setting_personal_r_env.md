# 개인 R 작업환경 세팅하기

R 환경을 한 번 세팅하고 나면 갈아엎기가 뭔가 귀찮다. 개인 분석환경도 도커를 통해 세팅해보자.

## Docker 세팅

다음과 같이 도커파일을 세팅한다. 

- TODO
    - tidyverse 이미지로 세팅해야 한다
    - 기본 rstudio 계정 말고, root 권한 받은 계정으로 새로 생성하거나 rstudio 계정에 root 권한 줘야 한다
    - 그래프 작업을 위한 폰트 세팅

```Dockerfile
FROM rocker/rstudio:latest

# Install Vim, Screen
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        vim \
        screen

# Change Default Locale to "ko_KR.UTF-8"
RUN sed -i 's/^# \(ko_KR.UTF-8\)/\1/' /etc/locale.gen \
    && localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

WORKDIR /home/rstudio/workspace
```

다음과 같이 `docker-compose.yaml` 파일을 생성한다. 

- 작업 환경간 파일 공유를 드랍박스로 하고 있기 때문에, 해당 작업 공간을 컨테이너 내부에서 사용할 수 있도록 볼륨을 마운트한다
- Rstudio가 기본적으로 8787포트를 사용하고 있기 때문에 해당 포트를 열고, 가끔 plumber나 shiny 쓸 것 대비해서 추가 포트를 하나 더 열었다

- TODO
    - 드랍박스에 업로드되지 않았으면 파일을 로컬 환경과 공유할 수 있도록 임의의 폴더를 추가로 마운트(아마도 tmp)
    - 컨테이너 생성될 때 `rstudio-server start` 명령을 실행하도록 수정

```yaml
version: '3.5'
services:
  miika_personal_svc:
    build:
      context: .
      dockerfile: ./Dockerfile
    container_name: miika_r_env
    volumes:
      - ~/Dropbox/workspace:/home/rstudio/workspace
    stdin_open: true
    tty: true
    ports:
      - 8787:8787
      - 18787:18787
    command: /bin/bash
```

## 실행

```bash
# 도커 이미지 빌드 + 컨테이너 생성
docker-compose up -d --build

# 컨테이너 내부로 진입 후 rstudio-server 실행
docker attach miika_r_env
rstudio-server start
```
