# CSS Block Element 가운데 정렬하기

- CSS로 `display: block` 속성을 가지는 엘리먼트를 가운데 정렬하려면 어떻게 해야 할까?
- 여러 가지 방법이 있지만, 그 중 다음과 같은 두 가지 방식을 정리해보자
    1. `display: flex`
    2. `display: table / table-cell`

## Flex 사용해서 정렬하기

- 원하는 block element를 div 태그로 감싼다
- 바깥을 감싼 div 태그에 `display: flex` 를 적용한다
    - `align-items: center` 와 `justify-content: center` 를 적용한다

## Table / Table-cell 사용해서 정렬하기

- 원하는 block element를 div 태그로 두 단계 감싼다
- 바깥쪽 div 태그에 `display: table` 를 적용한다
- 안쪽 div 태그에 `display: table-cell` 과 `vertical-align: middle` 을 적용한다
- 정렬하고자 하는 block element의 좌우 마진을 auto로 설정한다

# 코드 및 결과물 확인하기

- `div.block-elem` 태그를 가운데 정렬해보자

```html
<div id="contents">
    <!-- Flex를 이용한 가운데 정렬 -->
    <div id="flex" class="outer-div">
        <div class="block-elem">flex</div>
    </div>
    
    <!-- table/table-cell 을 이용한 가운데 정렬-->
    <div id="table" class="outer-div">
        <div class="inner-div">
            <div class="block-elem">table-cell</div>
        </div>
    </div>
</div>
```

```css
/* 공통 영역에 대한 CSS */
#contents {
    display: flex;
}

.outer-div {
    width: 200px;
    height: 200px;
    background-color: #eee;
    margin: 10px;
}

.block-elem {
    display: block;
    width: 80px;
    height: 40px;
    background-color: #0F4C81;
    color: #fff;
}

/* Flex를 이용한 가운데 정렬 */
#flex.outer-div {
    display: flex;
    align-items: center;
    justify-content: center;
}

/* display: table 을 이용한 가운데 정렬 */
#table.outer-div {
    display: table;
}

#table .inner-div {
    display: table-cell;
    vertical-align: middle;
}

#table .block-elem {
    margin: 0 auto;
}
```

![](fig/center_block_element.png)

# 참고자료

- [Vanseo Design - 6 Methods For Vertical Centering With CSS](https://vanseodesign.com/css/vertical-centering/)
- [display:table 속성을 이용하여 세로 가운데 정렬 구현하기](http://blog.302chanwoo.com/2016/07/vertical-center/)
- [Stack Overflow - Why is vertical-align: middle not working on my span or div?](https://stackoverflow.com/questions/16629561/why-is-vertical-align-middle-not-working-on-my-span-or-div)
