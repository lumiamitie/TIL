# Rprofile.site 위치 찾기

## 문제상황

- R Global 환경에 함수를 추가하고 싶어서 `Rprofile.site` 파일을 변경하려고 한다
- `Rprofile.site` 파일의 위치를 어떻게 알 수 있을까?

## 해결방법

- [Stackoverflow : Locate the ".Rprofile" file generating default options](https://stackoverflow.com/a/13736073)
- 다음 코드의 결과를 참고한다

```r
file.path(Sys.getenv("R_HOME"), "etc", "Rprofile.site")
# [1] "/usr/lib/R/etc/Rprofile.site"
```
