# R에서 AWS Athena를 사용하기 위한 ODBC 세팅하기

## 설치과정

rocker 의 R 도커 이미지 환경에서 설치하는 것을 기준으로 작성했다.

### ODBC 및 Athena Driver 설치

- unixODBC 라이브러리와 Athena ODBC 드라이버를 설치한다.

```bash
# Install the unixODBC library
apt-get install unixodbc unixodbc-dev

# Install Athena ODBC Driver
apt-get install alien
wget https://s3.amazonaws.com/athena-downloads/drivers/ODBC/SimbaAthenaODBC_1.1.6.1000/Linux/simbaathena-1.1.6.1000-1.el7.x86_64.rpm -P /tmp
alien -i /tmp/simbaathena-1.1.6.1000-1.el7.x86_64.rpm
```

### ODBC Driver 설정

- `odbcinst.ini` 파일을 저장할 위치를 찾아야 한다
    - 기본적으로 `/etc/odbcinst.ini` 로 설정되어 있다
    - `odbcinst -j` 명령을 통해 구체적인 위치를 확인할 수 있다

```bash
# 다음 명령을 실행하고, DRIVERS 위치를 확인한다
# - DRIVERS 항목에 해당하는 path를 확인한다 -> /etc/odbcinst.ini
odbcinst -j
# unixODBC 2.3.6
# DRIVERS............: /etc/odbcinst.ini
# SYSTEM DATA SOURCES: /etc/odbc.ini
# FILE DATA SOURCES..: /etc/ODBCDataSources
# USER DATA SOURCES..: /root/.odbc.ini
# SQLULEN Size.......: 8
# SQLLEN Size........: 8
# SQLSETPOSIROW Size.: 8
```

- 참고
    - 혹시라도 `ODBCINSTINI` 환경변수를 조정했다면 해당 값을 수정해서 파일 위치를 정한다.
    - `/etc/$ODBCINSTINI` 형태로 되어있는 것으로 보인다.

```bash
export ODBCINSTINI='odbcinst.ini'
odbcinst -j
# unixODBC 2.3.6
# DRIVERS............: /etc/odbcinst.ini
# SYSTEM DATA SOURCES: /etc/odbc.ini
# FILE DATA SOURCES..: /etc/ODBCDataSources
# USER DATA SOURCES..: /home/rstudio/.odbc.ini
# SQLULEN Size.......: 8
# SQLLEN Size........: 8
# SQLSETPOSIROW Size.: 8
```

- Driver 정보 파일이 위치할 path를 확인했으면, 다음과 같이 파일을 생성하고 `/etc/odbcinst.ini` 에 저장한다.

```
[ODBC Drivers]
Simba Athena ODBC Driver 64-bit=Installed

[Simba Athena ODBC Driver 64-bit]
Description=Simba Athena ODBC Driver (64-bit)
Driver=/opt/simba/athenaodbc/lib/64/libathenaodbc_sb64.so
```

### R ODBC 설정 및 컨넥션 생성

- R에서 odbc 라이브러리를 설치한다.
- `odbc::odbcListDrivers` 함수를 통해 Driver를 확인할 수 있다
    - 해당 함수를 실행시켰을 때 드라이버가 잡히지 않는다면(row 수가 0이라면), R 세션을 다시 실행하거나 `odbcinst.ini` 파일의 위치가 맞게 설정되어 있는지 확인해야 한다.

```r
# install ODBC
install.packages("odbc")

# 다음 함수를 실행시켰을 때, Driver가 잡혀야 한다
odbc::odbcListDrivers()
#                              name                       attribute                                              value
# 1                    ODBC Drivers Simba Athena ODBC Driver 64-bit                                          Installed
# 2 Simba Athena ODBC Driver 64-bit                     Description                  Simba Athena ODBC Driver (64-bit)
# 3 Simba Athena ODBC Driver 64-bit                          Driver /opt/simba/athenaodbc/lib/64/libathenaodbc_sb64.so
```

- 이제 다른 데이터베이스를 생성하는 것처럼 컨넥션을 생성하고, 쿼리를 요청하면 된다.

```r
# Make Connection
con <- DBI::dbConnect(
  odbc::odbc(),
  Driver             = "Simba Athena ODBC Driver 64-bit",
  S3OutputLocation   = "[ S3 Bucket Name ]",
  AwsRegion          = "[ AWS Region ]",
  AuthenticationType = "IAM Credentials",
  Schema             = "[ Schema Name ]",
  UID                = "[ AWS Access Key ]",
  PWD                = "[ AWS Secret Key ]"
)

# Get Data
data <- DBI::dbGetQuery(con, "SELECT * FROM schema.table")
```

# 참고자료

- [Databases using R | Athena](https://db.rstudio.com/databases/athena/)
- [Databases using R | Drivers](https://db.rstudio.com/best-practices/drivers/)
- [AWS Documents | Connecting to Amazon Athena with ODBC](https://docs.aws.amazon.com/athena/latest/ug/connect-with-odbc.html)
- [imba Athena ODBC Driver with SQL Connector Installation and Configuration Guide (pdf)](https://s3.amazonaws.com/athena-downloads/drivers/ODBC/SimbaAthenaODBC_1.1.6.1000/docs/Simba+Athena+ODBC+Install+and+Configuration+Guide.pdf)
- [r-dbi | odbc](https://github.com/r-dbi/odbc)
