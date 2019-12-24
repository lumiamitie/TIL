# Gitlab deploy token 적용하기

## 배경

- 도커 이미지를 생성할 때 특정 private git repository를 받아오려고 한다
- 그런데 생각해보니 git 저장소를 클론할 때 ID/PW를 입력하거나 public key를 등록해야 했다
- 보안 걱정없이 git 저장소를 클론할 수 있는 방법이 없을까?

## Deploy Token

Deploy token을 사용하면 아이디 또는 비밀번호 입력없이 git 저장소나 도커 레지스트리를 다운로드할 수 있다.

### 토큰 생성하기

- 토큰을 생성할 프로젝트(저장소)로 이동 > Settings > Repository
- Deploy Tokens 에서 Name 항목을 입력하고 Scope 설정 후 토큰을 생성한다
    - expire는 입력하지 않으면 기본적으로 만료일 없는 토큰으로 생성된다
    - username은 입력하지 않으면 기본 포맷으로 자동 생성된다
- 생성된 토큰을 잘 챙겨둔다

![](https://docs.gitlab.com/ee/user/project/deploy_tokens/img/deploy_tokens.png)

### 토큰 사용하기

- 토큰에서 `user_name` 과 `deploy_token` 값을 가지고 저장소를 clone한다

```bash
git clone http://<user_name>:<deploy_token>@gitlab.com/<group_name>/<repo_name>.git
```

# 참고자료

- [Gitlab Docs: Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/#git-clone-a-repository)
- [깃랩(Gitlab) CI/CD 튜토리얼](https://velog.io/@wickedev/Gitlab-CICD-%ED%8A%9C%ED%86%A0%EB%A6%AC%EC%96%BC-bljzphditt)
