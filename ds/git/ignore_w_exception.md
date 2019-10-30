# Git에서 디렉토리의 특정한 파일만 제외하고 gitignore 처리하기

## CASE

- 다음과 같은 폴더구조, 파일이 있다

```
- workspace/
    - spec/
        - sample.json
        - README.md
    - results/
        - README.md
```

- 여기서 `README.md`, `sample.json`을 제외하고 spec, results 폴더 하위에 들어가는 모든 파일을 git에서 무시하도록 하려면 어떻게 해야 할까?

## ANSWER

- `.gitignore` 파일에 다음과 같이 추가한다
    - `directory/**` 을 통해 특정 디렉토리 하위의 모든 파일을 무시하도록 처리한 뒤, 제외하려는 특정 파일을 명시한다

```
batch_workspace/json_spec/**
!batch_workspace/json_spec/README.md
!batch_workspace/json_spec/sample.json

batch_workspace/results/**
!batch_workspace/results/README.md
```

[참고: .gitignore로 무시된 디렉토리 안의 특정 파일만 추가하는 방법](https://hyeonseok.com/soojung/dev/2016/07/12/797.html)
