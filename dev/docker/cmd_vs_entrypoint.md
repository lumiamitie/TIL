# cmd vs entrypoint

- 두 항목 모두 컨테이너가 수행해야 하는 명령을 정의합니다.
- `cmd`
    - `cmd` 에 정의된 명령이 있더라도 `docker run` 으로 별도의 명령을 실행하면 대체됩니다.
- `entrypoint`
    - `entrypoint` 에 명시된 명령은 반드시 실행됩니다.
    - 만약 `entrypoint` 와 `cmd` 를 모두 사용할 경우, `cmd` 에 정의된 값을 `entrypoint` 의 파라미터 값으로 사용합니다.

```docker
# 최종적으로는 npm run-script start가 사용된다.
ENTRYPOINT [ "npm" ]
CMD [ "run-script", "start" ]
```

- [Dockerfile Entrypoint 와 CMD의 올바른 사용 방법](https://bluese05.tistory.com/77)
- [Docker CMD VS Entrypoint commands: What's the difference?](https://phoenixnap.com/kb/docker-cmd-vs-entrypoint)
