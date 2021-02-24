# R renv 를 이용한 디펜던시 세팅

## renv란?

renv는 재현 가능한 환경(Reproducible Environments)을 구축하기 위한 라이브러리다. 다음과 같은 세 가지 목표를 달성하고자 한다.

- 새로운 라이브러리를 설치하거나 업데이트하는 행위가 다른 프로젝트에 영향을 미쳐서는 안된다.
- 프로젝트 환경을 다른 컴퓨터로, 심지어 다른 플랫폼이더라도 쉽게 옮길 수 있어야 한다.
- 사용하는 라이브러리의 정확한 버전을 기록하여 프로젝트가 동일한 환경에서 실행될 수 있도록 한다.

# renv 활용하기

## 설치 및 프로젝트 세팅

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

## 디펜던시 기록 및 복구

해당 프로젝트에서 `library()` 나 `::` 를 사용해 라이브러리를 명시적으로 로딩하는 경우, 해당 라이브러리를 lock 파일 안에 기록할 수 있다. `renv::snapshot()` 을 사용한다.

예를 들어, 프로젝트 내에 다음과 같은 파일을 생성했다고 가정해보자.

```r
# test.R
library(ggplot2)

ggplot(diamonds, aes(x = cut)) + geom_bar()
ctx <- V8::v8()
```

파일을 저장한 뒤에 `renv::snapshot()` 을 실행해보면 다음과 같이 lock 파일을 업데이트하게 된다.

```r
renv::snapshot()
# The following package(s) will be updated in the lockfile:
#
# # CRAN ===============================
# - MASS           [* -> 7.3-53]
# - Matrix         [* -> 1.2-18]
# - lattice        [* -> 0.20-41]
# - mgcv           [* -> 1.8-33]
# - nlme           [* -> 3.1-149]
#
# # RSPM ===============================
# - R6             [* -> 2.5.0]
# - RColorBrewer   [* -> 1.1-2]
# - assertthat     [* -> 0.2.1]
#
# ...
#
# - Rcpp   [* -> 1.0.6]
# - V8     [* -> 3.4.0]
# - curl   [* -> 4.3]
#
# Do you want to proceed? [y/N]: y
# * Lockfile written to '~/myroom/renv.lock'.
```

## 도커와 함께 renv 사용하기

TODO

# 참고자료

- [renv Document](https://rstudio.github.io/renv/)
