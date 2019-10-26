# Mac에서 npm global 설치시 Permission Error 해결하기

## 문제상황

- `@vue-cli` 모듈을 전역으로 설치하려 했더니 다음과 같은 에러가 발생했다
- 아마 `sudo` 를 쓰면 해결되긴 하겠지만, `sudo` 없이 해결하는 방법은 없을까?

```bash
npm install -g @vue/cli

# npm WARN checkPermissions Missing write access to /usr/local/lib/node_modules
# npm ERR! path /usr/local/lib/node_modules
# npm ERR! code EACCES
# npm ERR! errno -13
# npm ERR! syscall access
# npm ERR! Error: EACCES: permission denied, access '/usr/local/lib/node_modules'
# npm ERR!  { [Error: EACCES: permission denied, access '/usr/local/lib/node_modules']
# npm ERR!   stack:
# npm ERR!    'Error: EACCES: permission denied, access \'/usr/local/lib/node_modules\'',
# npm ERR!   errno: -13,
# npm ERR!   code: 'EACCES',
# npm ERR!   syscall: 'access',
# npm ERR!   path: '/usr/local/lib/node_modules' }
# npm ERR!
# npm ERR! The operation was rejected by your operating system.
# npm ERR! It is likely you do not have the permissions to access this file as the current user
# npm ERR!
# npm ERR! If you believe this might be a permissions issue, please double-check the
# npm ERR! permissions of the file and its containing directories, or try running
# npm ERR! the command again as root/Administrator (though this is not recommended).

# npm ERR! A complete log of this run can be found in:
# npm ERR!     /Users/dtrmiika/.npm/_logs/2019-10-21T05_03_47_686Z-debug.log
```

## 해결방법

- <https://enyobook.wordpress.com/2016/08/05/npm-permission-문제-해결하기/>
- npm 라이브러리가 설치되는 디렉토리들에 대해 owner를 현재 사용자로 바꾸면 해결된다

```bash
# 다음 명령어를 실행시키고 password를 입력한다
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# 다시 모듈을 설치한다
npm install -g @vue/cli
```
