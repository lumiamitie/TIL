# cookieStorage : Storage API 형식으로 cookie 다루기

Cookie를 localStorage나 sessionStorage 와 동일한 API로 사용할 수 있도록 코드를 작성해보았다. (clear 빼고 구현)

```javascript
var CookieStorage = {
    get length() {
        return this.keys().length;
    },
    keys: function() {
        var cookieToObj = function(cookie) {
            return cookie.split(';').reduce(function(prev, current) {
                var ck = current.trim().split('=');
                prev[ck[0]] = ck[1];
                return prev
            }, {});
        };
        return Object.keys(cookieToObj(document.cookie))
    },
    setItem: function(name, value, ms, path) {
        var expires = '';
        if (ms) {
            expires = new Date();
            expires.setTime(expires.getTime() + ms);
            expires = ';expires=' + expires.toGMTString();
        } else {
            expires = ';expires=0';
        };
        document.cookie = name + '=' + encodeURIComponent(value) + expires + ';path=' + (path || '/');
    },
    getItem: function(name) {
        var cookiePattern = new RegExp('(^|;)[ ]*' + name + '=([^;]*)');
        var cookieMatch = cookiePattern.exec(document.cookie);
        return cookieMatch ? window.decodeURIComponent(cookieMatch[2]) : '';
    },
    removeItem: function(name) {
        this.setItem(name, 0, -1);
    }
};

// CookieStorage.length
// CookieStorage.keys()
// CookieStorage.setItem('test', 1, 100000)
// CookieStorage.setItem('test', 2, 100000)
// CookieStorage.getItem('test')
// CookieStorage.removeItem('test')
```

# 참고자료

- [MDN Web API : Storage](https://developer.mozilla.org/ko/docs/Web/API/Storage)
- `document.cookie` 를 object 로 변환하기
    - <https://stackoverflow.com/a/50452780>
- getter를 사용해 length 프로퍼티를 동적으로 계산
    - <https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Functions/get>
