# rmarkdown 에서 self-contained=FALSE 상태일 때 이미지를 base64로 임베딩하기

## 문제상황

- Rmarkdown HTML 문서를 작성할 때, `self-contained=FALSE` 옵션을 사용할 경우 외부의 CSS 및 JS 스크립트를 링크만으로 연결할 수 있다.
- 하지만 이렇게 사용할 경우 이미지를 base64로 임베딩하는 대신 파일로 연결되어, HTML 문서를 독립적으로 실행했을 때 이미지가 보이지 않는 문제가 발생한다.
- `self-contained=FALSE` 옵션을 사용하면서도 이미지를 base64로 임베딩하려면 어떻게 해야 할까?

## 해결방법

- Rmd 문서에서 다음과 같은 setup chunk를 추가한다.

```r
knitr::opts_knit$set(upload.fun = knitr::image_uri)
```

## 참고자료

- [Support base64 image output · Issue #944 · yihui/knitr](https://github.com/yihui/knitr/issues/944#issuecomment-71406010)
- [Options - Yihui Xie](https://yihui.org/knitr/options/)
