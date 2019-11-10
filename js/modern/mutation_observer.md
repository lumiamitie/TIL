# MutationObserver 간단 사용법 정리

`MutationObserver`는 DOM이 변경되는지 여부를 감시할 수 있다.

## 구조 설명

```javascript
// 생성자
let observer = new MutationObserver(
    callback // DOM이 변경될 때마다 실행될 콜백 함수
);

// 인스턴스
observer.observe(
    target_node, // DOM 변경을 감시할 노드
    options      // 어떤 변경사항을 감시할지 설정하기 위한 옵션
)
```

## 예시

```html
    <div id="mutation-target"></div>
    <button id="mutation-btn-01">Mutate Class</button>
    <button id="mutation-btn-02">Mutate Content</button>
    <button id="mutation-btn-03">Append Child List</button>
    <button id="mutation-btn-04">Disconnect Observer</button>
```

```javascript
let target = document.getElementById('mutation-target');

// MutationObserver 객체 생성
let observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        console.log(mutation);
    });
});

// 탐지 범위 설정
observer.observe(target, {
    attributes: true,
    childList: true,
    characterData: true,
    subtree: true || null,
    attributeOldValue: true || null,
    characterDataOldValue: true || null,
});

document.getElementById('mutation-btn-01').addEventListener('click', function() {
    // "mutated" 클래스가 이미 설정되어 있더라도 setAttribute가 동작하는 순간 observer가 동작한다
    target.setAttribute('class', 'mutated');

    /*
    addedNodes: NodeList []
    attributeName: "class"
    attributeNamespace: null
    nextSibling: null
    oldValue: "mutated" // 처음 실행시킬 때는 null
    previousSibling: null
    removedNodes: NodeList []
    target: div#mutation-target.mutated
    type: "attributes"
    */
});

document.getElementById('mutation-btn-02').addEventListener('click', function() {
    // textContent에 값을 덮어씌우는 경우 중복 실행되지 않는다
    target.textContent = 'Text!'

    /* 
    addedNodes: NodeList [text]
    attributeName: null
    attributeNamespace: null
    nextSibling: null
    oldValue: null
    previousSibling: null
    removedNodes: NodeList []
    target: div#mutation-target.mutated
    type: "childList"
    */
});

document.getElementById('mutation-btn-03').addEventListener('click', function() {
    // 하위 노드를 추가할 때마다 반복 실행된다
    let ul = document.createElement('ul');
    ['a', 'b', 'c'].forEach(d => {
        let li = document.createElement('li');
        li.textContent = d;
        ul.appendChild(li);
    });
    target.appendChild(ul);

    /*
    addedNodes: NodeList [ul]
    attributeName: null
    attributeNamespace: null
    nextSibling: null
    oldValue: null
    previousSibling: text
    removedNodes: NodeList []
    target: div#mutation-target
    type: "childList"
    */
});

document.getElementById('mutation-btn-04').addEventListener('click', function() {
    // disconnect 메서드를 사용하면 Mutation Observer 연결을 해제한다
    observer.disconnect();
});
```

# 참고

- [MDN : MutationObserver](https://developer.mozilla.org/ko/docs/Web/API/MutationObserver)
- [(HTML&DOM) MutationObserver](https://www.zerocho.com/category/HTML&DOM/post/5be24eacdb0c31001c4c5040)
