# 모바일 디바이스 여부를 확인해보자

모바일 디바이스 여부에 따라 다른 동작을 해야 하는 경우가 있다. 어떤 식으로 확인할 수 있을까?

1. User Agent를 파싱한다
2. MediaQuery를 사용한다 (JS에서는 `window.matchMedia` 를 사용한다)
3. Modernizr 등 Feature Detection 도구를 사용한다

간단히 [mobile-detect.js](https://hgoebl.github.io/mobile-detect.js/) 를 사용해 모바일 여부를 확인하는 스크립트를 작성해보자.

```html
<script src="https://cdn.jsdelivr.net/npm/mobile-detect@1.4.4/mobile-detect.min.js"></script>
<p>This is <span id="content-is-mobile">not</span> a mobile device.</p>
<ul>
    <li>navigator.userAgent</li>
    <ul>
        <li id="content-ua-original"></li>
    </ul>
    <li>Parsed by <i>mobile-detect</i></li>
    <ul>
        <li>Mobile : <span id="content-mobile"></span></li>
        <li>Detected OS : <span id="content-os"></span></li>
        <li>User Agent : <span id="content-ua"></span></li>
    </ul>
</ul>
```

```javascript
const updateContent = (selector, content) => {
    document.querySelector(selector).textContent = content || '-'
}

const setDisplay = (selector, value) => {
    document.querySelector(selector).style.display = value
}

const md = new MobileDetect(window.navigator.userAgent)

document.addEventListener('DOMContentLoaded', (e) => {
    if (md.mobile()) {
        setDisplay('#content-is-mobile', 'none')
    }
    updateContent('#content-ua-original', window.navigator.userAgent)
    updateContent('#content-mobile', md.mobile())
    updateContent('#content-os', md.os())
    updateContent('#content-ua', md.userAgent())
})
```

- 참고. <https://stackoverflow.com/questions/11381673/detecting-a-mobile-browser>
