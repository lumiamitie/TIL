# Git 삭제된 리모트 브랜치 정보를 로컬에서 제거하기

## 문제상황

- git branch 명령에 `-a` 또는 `-r` 명령을 사용해보니 원격 저장소에서는 이미 삭제된 브랜치들이 로컬에 여전히 남아있다
- 이미 원격 저장소에서 삭제된 브랜치들은 로컬에서도 보이지 않도록 반영하려면 어떻게 해야 할까?

```bash
git branch -a
# * master
#   remotes/origin/...
#   remotes/origin/...
#   remotes/origin/...
#   remotes/origin/HEAD -> origin/master
```

## 해결방법

- `git remote prune origin` 명령을 사용한다
    - 작업 전에 `--dry-run` 옵션을 추가해서 어떤 일이 일어날지 미리 확인해 볼 수 있다

```bash
# 실제로 작업을 수행하기 전에 --dry-run 옵션을 넣어서 돌려보면, 어떤 일이 일어날지 확인할 수 있다
git remote prune origin --dry-run
# Pruning origin
# URL: https://path/to/project.git
#  * [would prune] origin/...
#  * [would prune] origin/...
#  * [would prune] origin/...

git remote prune origin
# Pruning origin
# URL: https://path/to/project.git
#  * [pruned] origin/...
#  * [pruned] origin/...
#  * [pruned] origin/...

# 이제 불필요한 브랜치 정보들이 제거되었다
git branch -a
# * master
#   remotes/origin/HEAD -> origin/master
#   remotes/origin/master
```

# 참고자료

- [Cleaning up old remote git branches](https://stackoverflow.com/questions/3184555/cleaning-up-old-remote-git-branches)
- [Git - 리모트 브랜치](https://git-scm.com/book/ko/v2/Git-브랜치-리모트-브랜치)
- [git remote 관리 명령어 한눈에 보기](https://webisfree.com/2016-12-16/git-remote-관리-명령어-한눈에-보기)
