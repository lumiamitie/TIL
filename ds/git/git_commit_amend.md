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

# 마지막 커밋의 사용자 정보 변경하기

- 사용자 설정을 깜빡해서 의도하지 않은 유저 정보로 커밋을 하게 되었다면 어떻게 처리해야 할까?
- 직전 커밋이라면 다음과 같이 처리할 수 있다
    - 사용자 설정 후 `--amend` 옵션과 함께 커밋을 수정한다
    - 이 때 `--reset-author` 옵션을 추가한다

```bash
# 사용자 설정
git config user.name "UserName"
git config user.email "mymail@mail.com"

# 커밋 수정
git commit --amend --reset-author
```

참고로 그냥 `—-amend` 옵션을 쓰면 에디터가 뜨는데, 이 경우 이슈를 기록하기 위해 `#` 으로 시작하면 주석 처리가 되는 경우가 있다. 
이 때는 다음과 같이 `-m` 옵션을 통해 커밋 메시지를 추가하면 된다.

```bash
git config user.name "minho"
git config user.email "minho.lee@email.adress"
git commit --amend --reset-author -m '#1 깃헙 이슈를 달아볼까 합니다.'
```
