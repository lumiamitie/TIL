# R renv 를 이용한 디펜던시 세팅

## renv란?

TODO

## renv 설치하기

```r
# (1) renv 설치
install.packages('renv')

# (2) 현재 프로젝트에서 renv 시작하기
renv::init()
# * Initializing project ...
# * Discovering package dependencies ... Done!
# * Copying packages into the cache ... Done!
# The following package(s) will be updated in the lockfile:
#
# # RSPM ===============================
# - renv   [* -> 0.12.5]
#
# * Lockfile written to '~/myroom/renv.lock'.
# The renv support directory has not yet been created:
#
# 	~/.local/share/renv
#
# A temporary support directory will be used instead.
# Please call `renv::consent()` to allow renv to generate the support directory.
# Please restart the R session after providing consent.
#
#
# Restarting R session...
#
# * Project '~/myroom' loaded. [renv 0.12.5]
```

renv를 시작하면 다음과 같이 프로젝트 루트 폴더에 `renv.lock` 파일이 생성된다. 이 이후에 설치하는 라이브러리들은 프로젝트 폴더 내에 따로 격리된다.

```json
{
  "R": {
    "Version": "4.0.3",
    "Repositories": [
      {
        "Name": "CRAN",
        "URL": "https://packagemanager.rstudio.com/all/latest"
      }
    ]
  },
  "Packages": {
    "renv": {
      "Package": "renv",
      "Version": "0.12.5",
      "Source": "Repository",
      "Repository": "RSPM",
      "Hash": "5c0cdb37f063c58cdab3c7e9fbb8bd2c"
    }
  }
}
```

## 도커와 함께 renv 사용하기

TODO

# 참고자료

- [renv Document](https://rstudio.github.io/renv/)
