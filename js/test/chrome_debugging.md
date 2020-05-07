# Blackbox 설정: 특정 외부 스크립트를 디버깅하지 않도록 처리하기

디버깅 과정에서 **특정 스크립트를 무시하고 싶을 경우 해당 스크립트를 Blackbox** 처리할 수 있다. 
블랙박스 처리된 스크립트는 콜 스택 화면에 뜨지 않고, 코드를 단계별로 디버깅할 때 건너뛰게 된다. 다음과 같은 방법으로 스크립트를 블랙박스 처리할 수 있다.

- **Settings > Blackboxing** 탭에서 **Add Pattern** 을 클릭하고 블랙박스 처리하고자 하는 스크립트의 패턴을 등록한다
    - 예를 들어 `jquery-1.9.1.min.js` 를 블랙박스 처리하려면 다음과 같은 정규표현식 패턴을 등록한다
    - `jquery.+\.min\.js$`
- 개발자 도구 Sources 탭의 Editor pane에서 우클릭 후 **Blackbox script** 를 선택하면 해당 스크립트를 블랙박스로 등록한다

- [Google Developers Web Fundamentals : JavaScript Debugging Reference](https://developers.google.com/web/tools/chrome-devtools/javascript/reference?hl=ko#blackbox)
- [크롬 개발자도구 : 설정 (Settings) 사용하기](https://jamesdreaming.tistory.com/111)
