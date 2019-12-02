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
