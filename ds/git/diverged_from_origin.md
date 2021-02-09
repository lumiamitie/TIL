# Git : Your branch and 'origin/master' have diverged 문제

## 문제상황

- Gitlab에서 Github으로 이전하게 되면서 `master` branch 대신 `main` branch를 사용하게 되었다
- 그런데 git status를 실행할 때마다 다음과 같은 메세지가 발생한다

```bash
$ git status
# On branch main
# Your branch and 'origin/master' have diverged,
# and have 7 and 1 different commits each, respectively.
#   (use "git pull" to merge the remote branch into yours)
```

## 해결방법

- 여전히 원격저장소의 master 브랜치를 찾으려고 해서 발생하는 문제로 보인다
- 다음 명령을 사용해 upstream을 변경한다

```bash
git branch -u origin/main
```

[Git - 리모트 브랜치](https://git-scm.com/book/ko/v2/Git-브랜치-리모트-브랜치)
