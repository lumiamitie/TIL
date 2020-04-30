# git add 한 파일을 다시 unstage 상태로 변경하기

## 문제상황

- git add 명령을 잘못 사용해서 불필요한 파일을 Staged 상태로 만들어버렸다
- 해당 파일을 이번 커밋에 포함하지 않기 위해 다시 Unstaged 상태로 돌리려면 어떻게 해야 할까?

## 해결방법

- `git add` 명령을 사용하면 변경된 파일을 Staged 상태로 만든다
- 다시 Unstaged 상태로 되돌리려면 `git reset HEAD <filename>` 명령을 사용하면 된다

```bash
# (1) 변경된 모든 파일을 Staged 상태로 만들어버렸다
git add .

git status
# On branch master
# Your branch is up to date with 'origin/master'.
#
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#         modified:   src/component.js
#         modified:   src/index.css

# (2) 두 파일을 다시 Unstaged 상태로 되돌리고 상태를 확인해보자
git reset HEAD src/index.css
git reset HEAD src/component.js

git status
# On branch master
# Your branch is up to date with 'origin/master'.
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#         modified:   src/component.js
#         modified:   src/index.css

# no changes added to commit (use "git add" and/or "git commit -a")
```

# 참고자료

- [git stage에 add된 파일 다시 unstage상태로 되돌리기](https://devpouch.tistory.com/m/36?category=1023131)
- [2.4 Git의 기초 - 되돌리기](https://git-scm.com/book/ko/v2/Git%EC%9D%98-%EA%B8%B0%EC%B4%88-%EB%90%98%EB%8F%8C%EB%A6%AC%EA%B8%B0)
