# 로컬 브랜치에서 작업하던 내용을 원격 저장소 브랜치에 업로드하기

로컬 브랜치에서 작업하던 내용을 (아직 존재하지 않는) 원격 저장소 브랜치에 업로드하려면 어떻게 해야할까?

```bash
git push -u origin <localBranchName>:<remoteBranchNameToBeCreated>
```

- 참고로 위 명령을 수행하면 upstream이 `origin/<remoteBranchNameToBeCreated>` 로 변경된다고 한다
- upstream을 변경하고 싶다면, `git branch --set-upstream-to=origin/localBranch` 명령을 추가로 수행해야 한다

[Stackoverflow Answer | How do I push a new local branch to a remote Git repository and track it too?](https://stackoverflow.com/a/42902131)
