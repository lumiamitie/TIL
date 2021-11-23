# Rmarkdown 에서 html/md 를 조건부 렌더링하기

## 문제 상황

- R chunk가 아니라 html/md 영역을 조건부로 렌더링할 수 있을까?

```markdown
<!-- is_a_chunk_show=TRUE 이면 여기가 보여야 합니다. -->
이 링크는 보여야 합니다. [데이터라이즈 링크로 바로가기](http://team.datarize.ai/)

<!-- is_b_chunk_show=FALSE 이면 여기가 보이면 안됩니다. -->
이 링크는 보이면 안됩니다. [데이터라이즈 링크로 바로가기](http://team.datarize.ai/)
```

## 해결 방법

- `asis` 엔진을 사용한다.
    - `echo=TRUE` 인 항목은 렌더링되고, `echo=FALSE` 인 항목은 렌더링되지 않습니다.

```markdown
` ``{r}
is_a_chunk_show=TRUE
is_b_chunk_show=FALSE
` ``

` ``{asis echo=is_a_chunk_show}
마크다운 테스트 중입니다. [데이터라이즈 링크로 바로가기](http://team.datarize.ai/)
` ``

` ``{asis, echo=is_b_chunk_show}
마크다운 테스트 중입니다. [데이터라이즈 링크로 바로가기](http://team.datarize.ai/)
` ``
```

[15.3 Execute content conditionally via the asis engine | R Markdown Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/eng-asis.html)
