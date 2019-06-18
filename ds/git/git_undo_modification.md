# 특정 파일의 수정 내역 되돌리기

## 문제상황

- 웹팩을 바탕으로 프론트 작업을 하다보니 `package-lock.json` 파일이 종종 변경되는 경우가 있다
- git으로 관리하기 때문에 잘못 커밋했다가는 로컬과 서버 내 환경간에 충돌이 발생할까 우려가 됨
- 그냥 서버에서 빌드 후에 변경된 `package-lock.json` 의 수정 내역을 수정 전으로 되돌리고 싶다
- **특정 파일을 직전 커밋 상태로 되돌리려면 어떻게 해야 할까?**

## 해결방법

- https://stackoverflow.com/a/692329
- `git checkout -- <filename>` 을 사용한다
    - -- 없이도 작동하기는 하지만, 만약 파일명이 브랜치나 태그와 이름이 비슷할 수 있다면 다른 방식으로 동작해버릴 수 있기 때문에 --를 함께 쓰는 것이 안전하다
- 만약 파일이 staged 상태가 되었다면, reset 후 checkout 해야 한다
    - `git reset HEAD <filename>`
    - `git checkout -- <filename>`
