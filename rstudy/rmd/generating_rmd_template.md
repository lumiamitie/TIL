# Rmarkdown 템플릿 만들기

## Basic

1. 새로운 패키지를 만든다.
2. `inst/` 폴더 내부에 템플릿 관련 html 및 css 파일을 둔다.
    - 예시
        
        ```html
        <html>
          <head>
            <title>$title$</title>
          </head>
          <body>
          $body$
          </body>
        </html>
        ```
        
3. 템플릿 포맷 함수를 만든다.
    - 예시
        
        ```r
        #' @importFrom rmarkdown output_format knitr_options pandoc_options
        #' @export
        custom_report_html_format = function() {
          output_format(
            knitr = knitr_options(opts_chunk = list(dev = 'png')),
            pandoc = pandoc_options(
              to = "html",
              # customReportTemplate 패키지 내에 있는 inst/custom_report_template.html 위치의 파일을 사용한다.
              args = c('--template', system.file('custom_report_template.html', package = 'customReportTemplate'))
            ),
            clean_supporting = FALSE
          )
        }
        ```
        
4. Rmd 파일에 템플릿을 적용한다.
    - 예시
        
        `customReportTemplate::custom_report_html_format` 함수를 사용하는 경우.
        
        ```markdown
        ---
        title: "Untitled"
        output: customReportTemplate::custom_report_html_format
        ---
        
        간단한 HTML 문서가 생성됩니다.
        ```
        

## Details : pandoc 파라미터 추가하기

```r
#' Custom report format
#'
#' @param document_title document.title value for html document
#' @param self_contained Produce a standalone HTML file with no external dependencies
#'
#' @importFrom glue glue
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg
#' @export
custom_html_format = function(document_title='Custom HTML Template',
                              show_footer = TRUE,
                              self_contained = FALSE
                              ) {
  # HTML 템플릿 파일이 존재하는 위치를 입력한다.
  # 여기서는 직접 만든 customReportTemplate 패키지의 inst/custom_template.html 파일을 사용하도록 한다.
  args <- c('--template', system.file('custom_template.html', package = 'customReportTemplate'))
  
  # HTML 내에 포함될 pandoc 템플릿 변수를 추가하려면 rmarkdown::pandoc_variable_arg 을 사용한다.
  args <- c(args, pandoc_variable_arg('document_title', document_title))
  args <- c(args, pandoc_variable_arg('show_footer', show_footer))

  # TODO : --standalone 옵션이 필요한 이유?
  args <- c(args, '--standalone')

  # self_contained=TRUE 일 경우, 리소스가 html 파일 내에 임베딩 된다.
  if (self_contained) {
    args <- c(args, '--self-contained')
  }

  output_format(
    knitr = knitr_options(opts_chunk = list(dev = 'png')),
    pandoc = pandoc_options(to = "html", args = args),
    clean_supporting = FALSE
  )
}
```

## Details : pandoc 템플릿 문법 활용하기

- `$variable_name$` 으로 템플릿 변수를 출력할 수 있다.
- `$if(variable_name)$ ... $endif$` 로 조건문을 사용할 수 있다.
- for 문, 파이프 등 다양한 문법을 지원한다.

```html
<html>
  <head>
    <title>$document_title$</title>
  </head>
  <body>

  <!-- 마크다운이 HTML로 렌더링 되면 $body$ 영역에 붙는다. -->
  $body$
  
  $if(show_footer)$
    <div>Footer Contents!</div>
  $endif$

  </body>
</html>
```

# 참고자료

- R Markdown Chapter 18 : Creating New Formats
    - [Chapter 18 Creating New Formats | R Markdown: The Definitive Guide](https://bookdown.org/yihui/rmarkdown/new-formats.html)
- Custom HTML 템플릿 만들기
    - [7.9 Use a custom HTML template (*) | R Markdown Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/html-template.html)
- Pandoc 유저 가이드 : Template 관련 내용
    - [Pandoc User's Guide](https://pandoc.org/MANUAL.html#templates)
- output format 함수 관련 예시 소스코드
    - <https://github.com/rstudio/rmarkdown/blob/main/R/html_document.R>
- 템플릿 예시 소스코드
    - <https://github.com/rstudio/rmarkdown/tree/main/inst/rmd/h>
- 외부 JS/CSS 디펜던시 추가 관련 소스코드
    - 템플릿 함수 내 디펜던시 관련 영역 → <https://github.com/rstudio/rmarkdown/blob/main/R/html_document.R#L275>
    - 관련 함수들 정의된 곳 → <https://github.com/rstudio/rmarkdown/blob/main/R/html_dependencies.R>
