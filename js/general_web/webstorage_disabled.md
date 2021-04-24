# Web Storage를 사용할 수 없는 경우에 대해 정리하기

## 시크릿 모드 관련 이슈

- 대부분의 최신 브라우저는 탐색 기록과 쿠키를 남기지 않는 기능("사생활 보호 모드", "시크릿 모드" 등)을 가지고 있다.
- 이 기능을 사용할 경우 Web Storage와 호환되지 않는 경우가 많다.
- 사파리의 경우 Web Storage API는 존재하지만 최대 용량을 0바이트로 할당하여 어떠한 데이터도 입력할 수 없도록 한다.

[MDN | Web Storage API](https://developer.mozilla.org/ko/docs/Web/API/Web_Storage_API)

- 크롬에서 Cross Domain iframe을 사용하는 페이지를 시크릿 모드에서 사용할 경우 Web Storage를 사용할 수 없는 현상이 발생한다.
- "시크릿 모드에서 타사 쿠키 차단" 옵션에서 모든 쿠키를 허용하도록 수정하면 문제가 해결된다고 한다.

[StackOverflow | Failed to read the 'localStorage' property from 'Window': In Chrome Incognito mode and running in Iframe](https://stackoverflow.com/a/63226070)
