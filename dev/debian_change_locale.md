# Debian에서 로케일 변경하기

- `rocker/tidyverse` 도커 이미지를 보면 Debian을 사용한다
- 그런데 Debian의 경우 Ubuntu와 로케일 설정하는 방법이 조금 다른 것 같다
- shell 및 Dockerfile에서 로케일을 변경해보자

shell에서는 다음과 같이 로케일을 변경할 수 있다

```bash
sed -i 's/^# \(ko_KR.UTF-8\)/\1/' /etc/locale.gen
localedef -f UTF-8 -i ko_KR ko_KR.UTF-8

# 환경변수를 입력해서 bash를 새로 실행시켜보자
LC_ALL=ko_KR.UTF-8 bash
```

도커파일에는 다음과 같이 설정하면 된다

```Dockerfile
RUN sed -i 's/^# \(ko_KR.UTF-8\)/\1/' /etc/locale.gen
RUN localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8
```

# 참고자료

- [도커(Docker) 컨테이너 로케일 설정: 데비안(Debian), 우분투(Ubuntu) 이미지에서 한글 입력 문제](https://www.44bits.io/ko/post/setup_linux_locale_on_ubuntu_and_debian_container)
- [데비안에서 로켈을 설치 / 변경하는 방법은 무엇입니까?](https://qastack.kr/server/54591/how-to-install-change-locale-on-debian)
