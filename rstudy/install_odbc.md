# 리눅스 서버에 odbc 설치하기

```
# docker 내부에서
sudo -E apt-get install unixodbc-dev

------------------------- ANTICONF ERROR ---------------------------
Configuration failed because odbc was not found. Try installing:
 * deb: unixodbc-dev (Debian, Ubuntu, etc)
 * rpm: unixODBC-devel (Fedora, CentOS, RHEL)
 * csw: unixodbc_dev (Solaris)
 * brew: unixodbc (Mac OSX)
To use a custom odbc set INCLUDE_DIR and LIB_DIR manually via:
R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=...'
--------------------------------------------------------------------

# R에서
install.packages('odbc')
```

odbc 드라이버를 통해 Hive 연결하는 방법은 아직 리서치 진행중!
