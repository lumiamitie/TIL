# 패키지 설치중 강제종료로 인한 LOCK 문제 해결하기

## 문제상황

* R dplyr 패키지 업데이트중 문제가 발생하여 강제 종료함
* 다시 들어가서 작업하려 했더니 tidyverse 로드하는 과정에서 에러가 발생

```
> library('tidyverse')

S3 methods ‘[.fun_list’, ‘[.grouped_df’, ..............
were declared in NAMESPACE but not foundError: package or namespace load failed for ‘tidyverse’ in library.dynam(lib, package, package.lib):
 shared object ‘dplyr.so’ not found
```

* 따라서 dplyr 재설치를 시도했는데 다음과 같은 에러가 발생함!!

```
ERROR: failed to lock directory ‘/usr/local/lib/R/site-library’ for modifying
Try removing ‘/usr/local/lib/R/site-library/00LOCK-dplyr’

The downloaded source packages are in
    ‘/tmp/RtmpgCPB3M/downloaded_packages’
Warning message:
In install.packages("dplyr") :
  installation of package ‘dplyr’ had non-zero exit status
```

## 해결방법

* <https://stackoverflow.com/questions/14382209/r-install-packages-returns-failed-to-create-lock-directory>
* 강제 종료로 인해서 특정 디렉토리에 락이 걸려버린 상황
    * 1) 해당 디렉토리의 락을 풀어주고 진행하거나 ( <https://stackoverflow.com/a/48974126> )
    * 2) 락을 무시하고 강제 설치 ( <https://stackoverflow.com/a/14389028> )
* 2번방식으로 해결

```r
install.packages("dplyr", dependencies=TRUE, INSTALL_opts = c('--no-lock'))
```
