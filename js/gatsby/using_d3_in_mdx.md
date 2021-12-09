# MDX 에서 D3 사용하기

우선 `d3` 를 디펜던시에 추가한다.

```bash
cd site
yarn add d3
```

파일 구조는 다음과 같이 설정했다.

```bash
site
ㄴ content
  ㄴ notice
    ㄴ d3-visualization-test
      ㄴ index.mdx        # 아티클을 작성하는 MDX 파일
      ㄴ Graph.jsx        # D3 코드가 정의된 JSX 파일
      ㄴ graph.style.css  # 그래프 스타일링을 위한 CSS 파일
```

<details>
<summary>index.mdx</summary>
<div markdown="1">

```markdown
---
title: 시각화 테스트중입니다.
slug: d3-visualization-test
category: Notice
author: Minho Lee
tags: ['#d3']
date: 2021-12-09
---

import Graph from './Graph.jsx'

<Graph />
```

</div>
</details>

<details>
<summary>Graph.jsx</summary>
<div markdown="1">

```jsx
import React, { useEffect } from 'react'
import * as D3 from 'D3'
import './graph.style.css'

const Graph =  (props) => {
    useEffect(() => {
        // Plot Config
        const plot = {w: 400, h: 300}
        const margin = {t: 20, r: 20, b: 20, l: 40}

        // translate 값을 편하게 지정하기 위한 함수
        const trans = function(x, y) {
            return 'translate(' + x + ',' + y + ')'
        }

        // DATA
        const dataset = [
            [30, 40], [120, 115], [125, 90], [150, 160], [300, 190],
            [60, 40], [140, 145], [165, 110], [200, 170], [250, 190]
        ]

        // 데이터의 x, y 값 각각에 대해 최대값을 구한다
        const x_max = D3.max(dataset.map(function(d) {return d[0]}))
        const y_max = D3.max(dataset.map(function(d) {return d[1]}))

        // Scale Function
        const x = D3.scaleLinear().domain([0, x_max+20]).range([0, plot.w])
        const y = D3.scaleLinear().domain([0, y_max+20]).range([plot.h, 0])

        // Axis Config
        const x_axis = D3.axisBottom(x)
        const y_axis = D3.axisLeft(y)

        // SVG 생성
        const svg = D3
            .select('#graph')
            .append('svg')
            .attr('width', plot.w + margin.r + margin.l)
            .attr('height', plot.h + margin.t + margin.b)

        // 실제 그래프가 들어갈 공간은 미리 그룹으로 세팅
        const svg_plot = svg
            .append('g')
            .attr('transform', trans(margin.l, margin.t))

        // X축, Y축 생성
        svg_plot
            .append('g')
            .attr('class', 'x axis')
            .attr('transform', trans(0, plot.h))
            .call(x_axis)

        svg_plot
            .append('g')
            .attr('class', 'y axis')
            .call(y_axis)

        // marker(circle) 생성
        const circle = svg_plot
            .selectAll('.circle')
            .data(dataset)
            .enter()
            .append('circle')
            .attr('class', 'mark')
            .attr('cx', function(d) { return x(d[0]) })
            .attr('cy', function(d) { return y(d[1]) })
            .attr('r', 5)
    }, [])

    return (
        <>
            <div id="graph"></div>
        </>
    )
}

export default Graph
```

</div>
</details>

<details>
<summary>graph.style.css</summary>
<div markdown="1">

```css
#graph svg {
    /* svg 설정 */
    background-color: white;
}
    
#graph circle.mark {
    /* mark 모양 설정 */
    stroke: steelblue;
    stroke-width: 2.5px;
    fill: white;
}
    
#graph .axis path {
    /* x, y축 선 설정 */
    stroke: black;
    fill: none;
}
    
#graph .axis .tick line {
    /* grid 설정 */
    stroke: #eee;
    stroke-width: 0.5px;
}
    
#graph .axis .tick text {
    /* x, y축 눈금 텍스트 설정 */
    font-size: 0.8em;
}
```

</div>
</details>

# 참고자료

[Make Static Gatsby Stateful - using the new hooks](https://medium.com/@swathylenjini/make-static-gatsby-stateful-using-the-new-hooks-fb7c4843dd5a)
