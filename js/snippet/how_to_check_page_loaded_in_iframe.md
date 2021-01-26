# 페이지가 iframe 내부에서 실행되었는지를 JS로 확인할 수 있을까?

크게 두 가지 방법을 찾을 수 있었다.

1. `window.location !== window.parent.location`
2. `window.self !== window.top`

## 방법 1

```javascript
function isInIframe() { 
    if (window.location !== window.parent.location) { 
        return true
    }  else { 
        return false
    } 
} 
isInIframe() ? document.write("The page is in an iFrame") : document.write("The page is not in an iFrame")
```

## 방법 2

```javascript
function isInIframe () {
    try {
        return window.self !== window.top
    } catch (e) {
        return true
    }
};
isInIframe() ? document.write("The page is in an iFrame") : document.write("The page is not in an iFrame")
```

# 참고자료

[How to check a webpage is loaded inside an iframe or into the browser window using JavaScript?](https://www.geeksforgeeks.org/how-to-check-a-webpage-is-loaded-inside-an-iframe-or-into-the-browser-window-using-javascript/)
