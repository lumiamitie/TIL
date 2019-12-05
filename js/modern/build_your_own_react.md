# Build your own React

다음 문서를 읽고 필요한 부분을 정리해보자! <https://pomb.us/build-your-own-react/>

## Step 0: Review

다음 세 줄의 React Code를 가지고 시작해보자. 이 코드에서 차례대로 React용 코드를 걷어내고, Vanilla JS로 대체해보자.

```javascript
const element = <h1 title="foo">Hello</h1>
const container = document.getElementById("root")
ReactDOM.render(element, container)
```

첫 번째 줄은 JSX로, 유효한 JS 코드는 아니다. Babel 등의 도구를 사용해 JS 코드의 형태로 변환시킬 수 있다. 
변환은 간단한 방식으로 이루어진다. createElement 함수를 호출하고 태그명, 속성, 자식 정보를 파라미터로 넘긴다.

```javascript
// (1) JSX
const element = <h1 title="foo">Hello</h1>

// (2) JSX -> JS
const element = React.createElement(
    "h1",
    { title: "foo" },
    "Hello"
)

// (3) createElement 실행 결과
const element = {
    type: "h1",        // document.createElement 에서 사용할 태그명을 의미한다
    props: {
        title: "foo",
        children: "Hello", // 여기서는 문자열이지만 자식 노드가 많아지면 배열을 사용한다
    }
}
```

또 수정해야 하는 코드는 세 번째 줄, `ReactDOM.render` 함수를 호출하는 부분이다. DOM을 변화시키는 기능을 한다. 

```javascript
// (1) ReactDOM.render
ReactDOM.render(element, container)

// (2) 직접 element를 생성한다
const node = document.createElement(element.type)
node["title"] = element.props.title
​
const text = document.createTextNode("")
text["nodeValue"] = element.props.children
​
node.appendChild(text)
container.appendChild(node)
```

정리하면, 다음과 같이 동일한 로직을 React 없이 구현할 수 있게 되었다.

```javascript
//// Before ////
const element = <h1 title="foo">Hello</h1>
const container = document.getElementById("root")
ReactDOM.render(element, container)

//// After ////
const element = {
    type: "h1",
    props: {
        title: "foo",
        children: "Hello",
    }
}

const container = document.getElementById("root")

const node = document.createElement(element.type)
node["title"] = element.props.title
​
const text = document.createTextNode("")
text["nodeValue"] = element.props.children
​
node.appendChild(text)
container.appendChild(node)
```

## Step 1: The "createElement" Function

`createElement` 함수부터 우리가 직접 구현해보자. `createElement` 함수를 통해 JSX 코드를 JS로 변환할 수 있다.

```javascript
//// (1) JSX with React Code ////
const element = (
    <div id="foo">
        <a>bar</a>
        <b />
    </div>
)

const container = document.getElementById("root")
ReactDOM.render(element, container)

//// (2) JSX -> JS using "React.createElement" ////
const element = React.createElement(
    "div",
    { id: "foo" },
    React.createElement("a", null, "bar"),
    React.createElement("b")
)
const container = document.getElementById("root")
ReactDOM.render(element, container)
```

각 element에는 `type` 과 `props` 항목이 존재한다. element를 생성하는 함수를 만들어보자.

```javascript
// 1단계
function createElement(type, props, ...children) {
    return {
        type,
        props: {
            ...props, // Spread Opearator를 사용한다
            children, // Rest Parameter를 사용했기 때문에 항상 배열이다
        },
    }
}

createElement('div')
// {
//   "type": "div",
//   "props": { "children": [] }
// }

createElement("div", null, a)
// {
//   "type": "div",
//   "props": { "children": [a] }
// }

createElement("div", null, a, b)
// {
//   "type": "div",
//   "props": { "children": [a, b] }
// }
```

- `children` 배열에는 일반적인 문자열이나 숫자가 들어갈 수도 있다
    - 그런 경우에는 `"TEXT_ELEMENT"` 라는 type을 가지는 오브젝트로 감싸버리자
    - `createTextElement` 라는 함수를 통해 이 작업을 수행한다
- 실제로 리액트는 이런 작업을 하지 않지만, 이렇게 하면 코드를 더 단순하게 작성할 수 있다

```javascript
// 2단계
function createElement(type, props, ...children) {
    return {
        type,
        props: {
            ...props,
            children: children.map(child =>
            typeof child === "object"
                ? child
                : createTextElement(child)
            )
        }
    }
}

function createTextElement(text) {
    return {
        type: "TEXT_ELEMENT",
        props: {
            nodeValue: text,
            children: [],
        }
    }
}
```

- `React.createElement` 함수를 교체하기 전에, 리액트를 대신할 라이브러리 이름을 결정해보자
- 교육적인(didact) 목적에 사용한다는 의미에서 **Didact** 라는 이름을 사용한다

```javascript
const Didact = {
    createElement,
}
```

babel이 인식할 수 있도록 아래와 같이 주석을 달아두면, JSX를 트랜스파일할 때 명시된 함수를 사용하게 된다.

```javascript
/** @jsx Didact.createElement */
const element = (
    <div id="foo">
        <a>bar</a>
        <b />
    </div>
)
const container = document.getElementById("root")
ReactDOM.render(element, container)
```

## Step 2: The "render" Function

`ReactDOM.render` 함수를 다시 작성해보자. 우선 DOM을 추가하는 것에만 집중해보자.

여기까지 하면 JSX를 DOM으로 렌더링할 수 있게 된다.

```javascript
function render(element, container) {
    // type 값을 통해 엘리먼트를 생성한다
    // - 이 때, text element인지 여부에 따라 다른 엘리먼트를 생성한다
    const dom = element.type == "TEXT_ELEMENT"
        ? document.createTextNode("")
        : document.createElement(element.type)

    // 엘리먼트의 props 항목을 노드에 추가한다
    const isProperty = key => key !== "children"
    Object.keys(element.props)
    .filter(isProperty)
    .forEach(name => {
        dom[name] = element.props[name]
    })

    // 자식 노드가 있다면 재귀적으로 엘리먼트를 생성한다
    element.props.children.forEach(child =>
    render(child, dom)
    )
​
    // 생성한 노드를 컨테이너에 추가한다
    container.appendChild(dom)
}

// Didact에 render 함수를 추가한다
const Didact = {
    createElement,
    render,
}
​
/** @jsx Didact.createElement */
const element = (
    <div id="foo">
    <a>bar</a>
    <b />
    </div>
)

// 루트 컨테이너를 생성하고 렌더링한다
const container = document.getElementById("root")
Didact.render(element, container)
```

## Step 3: Concurrent Mode

작업을 더 진행하기 전에 리팩토링을 해보자.  `render` 함수의 재귀 부분에는 문제가 있다.

일단 렌더링 작업을 시작하면, 엘리먼트 트리를 전부 렌더링하기 전에는 작업을 멈출 수 없다. 
따라서 트리가 커져서 작업 속도가 너무 길어지면 메인 스레드가 멈출 우려가 있다. 
사용자 입력을 받거나 애니메이션을 처리하는 등 중요한 작업을 수행해야 할 때도 렌더링이 끝나기를 기다려야 한다. 

```javascript
function render(element, container) {
    ...

    // 재귀 로직에서 성능상 문제가 발생할 수 있다
    element.props.children.forEach(child =>
    render(child, dom)
    )

    ...
}
```

따라서 이러한 문제를 해결하기 위해, 작업을 작은 단위로 쪼갠다. 
각각의 작은 작업을 마치면 브라우저가 중간에 끼어들어서 필요한 작업을 수행할 수 있도록 한다. 
이를 위해 `requestIdleCallback` 함수를 사용한다. 
`setTimeout` 과 비슷하지만, 실행시점을 직접 입력하는 대신 **메인 스레드가 유휴 상태가 될 때 콜백 함수를 실행시킨다.**
(현재 리액트는 `requestIdleCallback` 대신 scheduler 패키지를 사용한다.)

```javascript
let nextUnitOfWork = null
​
function workLoop(deadline) {
    let shouldYield = false
    while (nextUnitOfWork && !shouldYield) {
    // 반복문이 시작되면 처음으로 해야 할 일을 설정해주어야 한다
    // - 아직은 performUnitOfWork 함수가 구현되지 않았다
    // - performUnitOfWork 함수는 현재 주어진 작업을 수행하고, 다음 해야 할 작업을 반환한다
    nextUnitOfWork = performUnitOfWork(
        nextUnitOfWork
    )
    // deadline 파라미터를 통해 브라우저가 권한을 가져가려면 시간이 얼마나 남았는지 알 수 있다
    shouldYield = deadline.timeRemaining() < 1
    }
    requestIdleCallback(workLoop)
}
​
requestIdleCallback(workLoop)

// 현재 주어진 작업을 수행하고, 다음 해야 할 작업을 반환한다
function performUnitOfWork(nextUnitOfWork) {
    // TODO
}
```
