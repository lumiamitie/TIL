# Mac 환경에 nvm 설치하기

<https://github.com/creationix/nvm> 에서 설치방법 확인하여 진행하면 된다.

다음 스크립트를 실행시키면 설치가 시작된다.

```bash
# Install Script
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
```

설치가 완료되었는지 확인하려면 다음 스크립트를 실행한다.

```bash
command -v nvm
```

여기서 *"nvm"* 이라는 결과가 나와야 설치가 완료된 것.
아무런 메세지도 나오지 않아서 스크립트 출력을 확인해보니 다음과 같은 문구가 있었다.

> Profile not found

```
=> Compressing and cleaning up git repository

=> Profile not found. Tried ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile.
=> Create one of them and run this script again
   OR
=> Append the following lines to the correct file yourself:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
```

`.bash_profile` 파일이 없어서 발생하는 문제이므로, 해당 파일을 생성해주면 된다.

```bash
touch ~/.bash_profile
```

다시 설치 스크립트 실행시키고, 터미널을 재시작하거나 `source ~/.bash_profile` 를 실행시킨다.

```bash
# 다시 설치
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# .bash_profile 에 등록된 내용을 반영한다
source ~/.bash_profile

# 무사히 설치된 것을 확인할 수 있다
command -v nvm
>> nvm
```

특정 버전의 node를 설치하기 위해서는 `nvm install <version>` 명령어를 사용한다.

```bash
# node 10.15.3 설치하기
nvm install 10.15.3

# node 10.15.3 사용
nvm use 10.15.3
```
