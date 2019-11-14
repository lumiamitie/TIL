# SSH Port Forwarding (Tunneling)

- SSH 포트 포워딩이란?
    - SSH 서버를 Gateway나 Proxy 서버처럼 활용해서 외부에 접속하는 것을 말한다
    - SSH 터널링 (Tunneling) 이라고도 한다
- 크게 세 가지 종류가 있다
    - **Local**
        - SSH를 통해 서버에 접속하여 사용한다
            - Application Client = SSH Client
            - Application Server = SSH Server
        - 웹 서버에서 특정 포트의 연결만 허용할 때 사용할 수 있다
    - **Remote**
        - Local과 반대로 동작한다
            - Application Client = SSH Server
            - Application Server = SSH Client
        - 서버 내부로의 모든 연결이 차단되어 있지만 외부로 나가는 패킷은 허용되어 있을 때 사용할 수 있다
    - Dynamic
        - 다양한 범위의 포트로부터 들어오는 요청을 처리할 수 있다

## SSH 포트 포워딩 사용하기

```bash
# Local Port Forwarding
ssh -L [ 로컬에서 사용할 리스닝 포트 ]:[ 최종적으로 접근할 주소 (IP:Port) ] [ SSH Server 주소 ]

# Remote Port Forwarding
ssh -R [ 원격에서 사용할 리스닝 포트 ]:[ 포워딩할 서버 주소 (IP:Port) ] [ SSL Server 주소 ]

# Dynamic Port Forwarding
???
```

## 참고자료

- <https://blog.naver.com/alice_k106/221364560794>
- <http://linux.systemv.pe.kr/ssh-포트-포워딩/>
- [SSH Port Forwarding 이해하기 (해커의 관점에서의 이론)](https://itsaessak.tistory.com/171)
- [SSH Tunneling - Local, Remote & Dynamic](https://dev.to/__namc/ssh-tunneling---local-remote--dynamic-34fa)
