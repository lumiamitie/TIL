# Datetime 과 Unix Timestamp 변환하기

초 단위의 유닉스 타임스탬프를 파이썬 datetime 객체로 변환하거나, 그 반대의 작업을 수행하는 방법에 대해 알아보자.

```python
import datetime
import time

current_dttm = datetime.datetime.now()
# datetime.datetime(2020, 5, 10, 21, 36, 32, 28163)

# (1) Datetime -> Unix Timestamp
time.mktime(current_dttm.timetuple())
# 1589114192.0

# (2) Unix Timestamp (seconds) -> Datetime
datetime.datetime.fromtimestamp(1589114192)
# datetime.datetime(2020, 5, 10, 21, 36, 32)
```

- [timestamp를 datetime으로, datetime을 timestamp로 변환하는 방법](https://ourcstory.tistory.com/109)
- [타임스탬프(Timestamp) 프로그래밍 기초](https://allenjeon.tistory.com/235)
