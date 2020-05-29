# React에서 텍스트 줄바꿈 사용하기

- 리액트에서는 보안 이슈로 인해 html 태그가 들어있는 문자열을 렌더링할 때 태그를 문자열 그대로 출력한다
- 그렇다면 문자열을 렌더링 할 때 강제로 줄바꿈을 추가하려면 어떻게 해야 할까?
- `\n` 을 기준으로 줄바꿈하도록 다음과 같이 적용할 수 있다

```jsx
const Text = ({ value }) => {
  // 로컬에서 사용할 때는 \n 를 썼는데, jsFiddle 에서 하려니 \\n를 써야 \n로 처리되었다
  // Babel 파싱 과정에서 발생하는 차이인 것 같다
	return (
    <React.Fragment>
      { value.split('\\n').map((line, idx) => <span key={idx}>{line}<br /></span>) }
    </React.Fragment>
  )
}

const App = () => {
	return (
  	<div>
      <Text value="줄바꿈을\n할 수 있어요"></Text>
  	</div>
  )
}

ReactDOM.render(<App />, document.querySelector("#app"))
```

# 참고자료

- [Tip: string 형태의 html을 렌더링하기, newline을 BR 태그로 변환하기](https://velopert.com/1896)
