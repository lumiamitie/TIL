# Object.assign 없이 2개의 오브젝트 합치기

`Object.assign` 을 사용하면 다음과 같이 두 개의 object를 합칠 수 있다.

```javascript
let A = {name: 'ABC', type: 'none'};
let B = {name: 'BCD', value: 1};

Object.assign(A, B)
// {name: "BCD", type: "none", value: 1}
```

그런데 `Object.assign` 은 IE에서는 사용할 수 없다. ES5를 지원하지 않는 다양한 환경에서 사용할 수 있도록 비슷한 역할을 수행하는 함수를 작성해보자.

```javascript
function mergeObject (x, y) {
    // https://stackoverflow.com/a/42091680
    var objs = [x || {}, y || {}];
    var result = objs.reduce(function(a, b) {
        Object.keys(b).forEach(function(k) {
            a[k] = b[k];
        });
        return a;
    }, {});
    return result;
};

mergeObject({ name: 'ABC', type: 'none' }, { name:'BCD', value: 1 });
// {name: "BCD", type: "none", value: 1}

mergeObject({ name: 'ABC', type: 'none' }, 11);
// {name: "ABC", type: "none"}

mergeObject({}, undefined);
// {}
```

# 참고자료

- <https://stackoverflow.com/a/42091680>
- [MDN : Object.assign()](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Object/assign)
