# RStudio에서 한글 타이핑 중에 발생하는 ERROR system error 84 (Invalid or incomplete multibyte or wide character) 문제 해결하기

## 문제상황

- R 4.1.2 + RStudio Server 2021.09.1 Build 372 사용중
- 한글 타이핑이 매우 느리며, 한글을 타이핑하면 주기적으로 다음과 같은 에러가 등장한다.
    - `ERROR system error 84 (Invalid or incomplete multibyte or wide character)`

```
2021-12-19T07:44:08.203644Z [rsession-rstudio] ERROR system error 84 (Invalid or incomplete multibyte or wide character) [str: 불가능하다, len: 15, from: UTF-8, to: ISO8859-1]; 
OCCURRED AT rstudio::core::Error rstudio::r::util::{anonymous}::iconvstrImpl(const string&, const string&, const string&, bool, std::__cxx11::string*) src/cpp/r/RUtil.cpp:187; 
LOGGED FROM: rstudio::core::Error rstudio::session::modules::spelling::{anonymous}::checkSpelling(const rstudio::core::json::JsonRpcRequest&, rstudio::core::json::JsonRpcResponse*) src/cpp/session/modules/SessionSpelling.cpp:225
```

## 해결방법

- 실시간 문법 체크 기능의 오류로 보인다.
- `Tools > Global Options > Spelling > Use real time spell-checking` 체크박스를 해제한다.
