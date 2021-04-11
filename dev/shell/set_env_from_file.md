# Shell 에서 .env 파일의 내용을 바로 환경변수에 등록하기

## 문제상황

- 필요한 환경변수를 `.env` 파일에 저장해두었는데, bash 쉘을 새로 생성 하는 등 기존의 환경변수가 초기화되는 상황이 종종 발생했다.
- `.env` 파일을 불러와서 바로 환경변수에 등록할 수 있는 방법이 있을까?

```
# .env 는 다음과 같은 형태로 구성되어 있다
HOST=service.host.com
USER=miika
PASSWORD=pass
PORT=3306
```

## 해결방법

- 스크립트가 동작할 때 `.env` 파일로부터 환경변수를 다시 읽어오도록 한다.
    - `grep -v` 를 통해 # 로 시작하는 줄은 무시하도록 한다
    - `xargs` : 앞 명령어의 결과를 다음 명령어의 인자로 사용한다
    - → 주석을 제외한 항목을 `.env` 파일에서 불러오고, 해당 내용을 `export` 함수의 인자로 전달하는 방식으로 동작한다.
- 정리하면, 아래와 같은 스크립트를 통해 `.env` 파일의 내용을 바로 환경변수로 등록할 수 있다.

```python
# .env 파일을 읽어서 환경변수로 등록하는 스크립트
export $(grep -v '^#' .env | xargs)
```

# 참고자료

[StackOverflow | Set environment variables from file of key/value pairs](https://stackoverflow.com/a/20909045)
