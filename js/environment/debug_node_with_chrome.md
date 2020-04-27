# 크롬 브라우저에서 Node 디버깅하기

## Node Inspector Agent

- node를 실행시킬 때 inspector를 켤 수 있다
- 기본적으로는 9229 포트로 설정되어 있다

[Node Debugging : Command Line Options](https://nodejs.org/en/docs/guides/debugging-getting-started/#command-line-options)

```bash
# Node의 Inspector Agent를 켠다
# * 127.0.0.1:9229
node --inspect

# 원하는 host, domain을 설정할 수 있다
# * host : 0.0.0.0
# * port : 12345
node --inspect=0.0.0.0:12345
```

## Chrome 연결하기

- **Chrome Devtools > Devices** (chrome://inspect/#devices)
    - Discover Network targets를 체크한다
    - 기본 포트 이외의 포트로 연결할 경우, configure를 선택해서 원하는 포트를 추가한다
    - Node의 inspector agent를 켜면, 화면 하단의 Remote Target에서 확인할 수 있다
    - Target에서 inspect 버튼을 클릭하면, 해당 노드 세션의 디버깅이 가능한 개발자 도구 화면이 뜬다


## 어떻게 활용할 수 있을까?

- [TOAST UI FE Guide : 디버깅](https://ui.toast.com/fe-guide/ko_DEBUG/)
- [Google Developers : 메모리 문제 해결](https://developers.google.com/web/tools/chrome-devtools/memory-problems?hl=ko)
