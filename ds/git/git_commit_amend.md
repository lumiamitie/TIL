# 마지막 커밋 변경하기

## 문제상황

- 커밋메세지를 잘못 남겼다, 또는 커밋 내용을 수정해야 한다 등등
- 직전의 커밋 내용을 변경하려면 어떻게 해야 할까?

## 해결방법
- `git commit --amend` 를 사용한다
- https://backlog.com/git-tutorial/kr/stepup/stepup7_1.html
- 만약 커밋 내용 자체를 변경해야 한다면 변경한 내용들 add 해두고 `git commit --amend` 를 사용한다

```
git commit --amend

## 다음과 같은 내용으로 vim이 뜬다 ##########################################################################

기존 Commit Message가 뜨는 영역!!!!

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Fri Mar 22 13:22:50 2019 +0900
#
# On branch master
# Your branch is up to date with 'origin/master'.
#
# Changes to be committed:
#       renamed:    ds/intro_to_causal_inference.md -> ds/intro_to_causal_inference/01_introduction.md
#
```

* 저 위에서 기존 커밋 메시지를 변경하고 저장하면 직전 커밋 메세지를 변경할 수 있다
* git push --force 로 강제 push 하면 끝
