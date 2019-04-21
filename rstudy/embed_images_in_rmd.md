# R markdown에 이미지 임베드하고 세부 조정하기

마크다운 문법을 통해 이미지를 쉽게 붙여넣을 수 있지만, 이 경우 이미지의 사이즈나 정렬같은 세부조정이 어렵다.
특히 `xaringan` 라이브러리로 슬라이드를 만들려고 할 때 이미지 세부조정의 필요성을 느꼈다.

마침 자료를 만들다가 [Tips and tricks for working with images and figures in R Markdown documents](http://zevross.com/blog/2017/06/19/tips-and-tricks-for-working-with-images-and-figures-in-r-markdown-documents/)
라는 문서를 통해 필요한 기능들을 알게되었다.

가장 기본적인 방법으로, 마크다운 문법을 통해 이미지를 붙여넣을 경우 다음과 같이 할 수 있다.

    ![Alt](path/to/image.png)

동일한 기능을 `knitr` 라이브러리의 `include_graphics` 함수로 대체할 수 있다.
R markdown Code Chunk 안에 들어있다면 다음과 같은 형태가 된다.

    ```{r}
    knitr::include_graphics('path/to/image.png')
    ```

Chunk를 통해 이미지를 컨트롤 할 경우, 사이즈를 쉽게 조절할 수 있다는 장접이 있다.

- chunk option에서 `out.width='50%'` 로 설정할 경우 이미지의 크기가 50%로 줄어든다
- `fig.align='center'` 로 설정하면 이미지가 가운데 정렬된다


    ```{r, out.width='50%', fig.align='center'}
    knitr::include_graphics('path/to/image.png')
    ```
