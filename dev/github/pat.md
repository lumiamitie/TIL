# github CLI로 PAT 등록하기

- Github CLI를 통해 PAT 키를 등록해 둘 수 있다.
    - 이 때 사용하는 PAT 키는 `repo` `read:org` `workflow` 권한을 가지고 있어야 한다.

```bash
# gh를 설치한다
brew install gh

# github 인증한다
# 4번째 선택지에서 Paste an authentication token 을 선택한다.
gh auth login

# ? What account do you want to log into? GitHub.com
# ? What is your preferred protocol for Git operations? HTTPS
# ? Authenticate Git with your GitHub credentials? Yes
# ? How would you like to authenticate GitHub CLI? Paste an authentication token
# Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
# The minimum required scopes are 'repo', 'read:org', 'workflow'.
# ? Paste your authentication token: ****************************************
# - gh config set -h github.com git_protocol https
# ✓ Configured git protocol
# ✓ Logged in as ------
```

- [Caching your GitHub credentials in Git - GitHub Docs](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git)
- [gh auth login](https://cli.github.com/manual/gh_auth_login)
