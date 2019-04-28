# Remote Branch 다루기

## 리모트에 있는 특정한 브랜치만 클론해오기

- <https://www.slipp.net/questions/577>
- `git clone -b <branch_name> <repository url>`

## 리모트 브랜치에 있는 user/miika 브랜치만 클론해오기

```
git clone -b user/miika https://github.com/lumiamitie/TIL.git
```

## 리모트 브랜치에 push하기

- <https://git-scm.com/book/ko/v1/Git-브랜치-리모트-브랜치#Push하기>
- `git push origin <branch_name>`

```
git push origin user/miika
```
