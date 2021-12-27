# 커스텀 템플릿으로 빌드한 rmd 문서에서 htmlwidgets가 제대로 동작하지 않는 문제

## 문제상황

`rmarkdown::output_format` 을 통해 커스텀 템플릿 (html 문서도 변경)을 생성했더니, `DT`, `reacttable` 등 htmlwidgets 기반의 라이브러리가 동작하지 않는 문제가 발생했다.

## 해결방법

우선 템플릿 html 파일에 다음 항목을 필수적으로 추가해야 한다.

```html
<head>
  ...

  $for(header-includes)$
    $header-includes$
  $endfor$

  ...
</head>
```

그리고 템플릿 함수를 만들 때, rmarkdown::output_format 대신 rmarkdown::html_document 을 베이스로 한다.

```r
template <- function(self_contained = FALSE) {
  # ...
  rmarkdown::html_document(
    toc = FALSE,
    fig_width = 6.5,
    fig_height = 4,
    theme = NULL,
    css = NULL,
    section_divs = FALSE,
    template = system.file('template.html', package = 'reportTemplatePackage'),
    self_contained = self_contained,
    pandoc_args = args
  )
}
```

# 참고자료

<https://bookdown.org/yihui/rmarkdown/format-derive.html#format-derive>
