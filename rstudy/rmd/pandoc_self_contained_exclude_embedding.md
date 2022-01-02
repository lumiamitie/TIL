# pandoc 에서 self-contained 옵션 사용할 때, 특정 엘리먼트만 제외하도록 처리하기

## pandoc 의 self-contained 옵션

- rmarkdown 등에서 사용하는 pandoc은 `--self-contained` 옵션을 사용하여 빌드할 경우, 연결된 모든 스크립트, 스타일시트, 이미지 등을 `data:` URI를 통해 임베딩한다.
    - 절대경로로 입력된 스크립트, 스타일시트, 이미지를 대상으로 한다.
- 그런데 어디서든 동작할 수 있도록 self-contained 옵션을 기본으로 하면서도, 용량이 크거나 항상 최신 버전을 보도록 하기 위한 목적으로 특정 파일만 제외하고 싶을 때도 있다.
- 이러한 경우에는 해당 엘리먼트에 `data-external="1"` attribute 를 추가하면 된다.

```html
<!-- 임베딩을 원하지 않는 항목에는 data-external="1" 을 추가한다. -->
<link href="https://unpkg.com/tailwindcss@^2/dist/tailwind.min.css" rel="stylesheet" data-external="1">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet" data-external="1">
<script src="https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.11.1/tocbot.min.js" data-external="1"></script>
```

# 참고자료

[Pandoc User's Guide](https://pandoc.org/MANUAL.html#options-affecting-specific-writers)
