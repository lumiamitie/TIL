# 특정 페이지에 원하는 스크립트가 설치되었는지 확인하기

Getsitecontrol 서비스를 살펴보니, 설치 스크립트가 목표 페이지에 설치되었는지 확인할 수 있는 기능이 있다.
JS 단에서 특정 도메인의 스크립트가 존재하는지 여부를 확인하려면 어떻게 해야 할까?

## 해결 방법

모든 script 태그의 src 프로퍼티를 확인하여 체크할 수 있다.

```javascript
var pattern = 'l.getsitecontrol.com'
var currentScript = getCurrentScript(pattern);
if (currentScript) {
    console.log('Target script exists!')
}

function getCurrentScript(pattern) {
    var urlPattern = new RegExp(pattern);
    var currentScript = (Array.prototype.slice.call(document.getElementsByTagName('script'))
        .map(d => d.src)
        .filter(src => urlPattern.exec(src))
    );
    return currentScript.length > 0 ? currentScript[0] : undefined;
};
```
