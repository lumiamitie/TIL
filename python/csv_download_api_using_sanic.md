# Sanic을 이용한 CSV 다운로드 API 만들기

**Sanic**은 Flask와 유사한 형태를 가진 웹서버이며, Python 3.5 이상 버전에서 동작한다. Async request handler를 지원하기 때문에 async / await 문법을 활용할 수 있다.

쿼리를 통해 데이터를 받아온 이후에 콜백함수를 구성하고, `stream` 메서드를 통해 반영한다. 콜백함수 내부에서 `response`를 반환할 때, `await` 처리를 하지 않으면 데이터를 처리하기 전에 응답되어 버린다. 따라서 클라이언트에서는 빈 CSV 파일을 받게 된다. 

간단한 쿼리가 주어졌을 때, CSV 파일로 다운로드 할 수 있는 API 목업을 구성해보았다.

```python
from sanic import Sanic
from sanic.response import stream
import MySQLdb
from contextlib import contextmanager

app = Sanic(__name__)


# WITH 문을 통해 db연결을 관리하기 위한 Context Manager
@contextmanager
def connect_db():
    db_settings = {
        'host': '127.0.0.1',
        'user': 'user',
        'port': 13306,
        'passwd': 'passwd',
        'db': 'dbname',
        'charset': 'utf8'
    }

    db = MySQLdb.connect(**db_settings)
    yield db
    db.close()


@app.route('/test/dbstream')
async def stream_db_test(request):
    '''Example: Query to CSV'''

    SAMPLE_QUERY = "SELECT * FROM table LIMIT 100"

    # Data
    with connect_db() as db:
        cur = db.cursor()
        cur.execute(SAMPLE_QUERY)
        data = cur.fetchall()

    # Stream을 위한 코루틴 콜백
    async def stream_db_data(response):
        for d in data:
            await response.write(','.join(map(str, d)) + '\n')

    # CSV 포맷으로 스트림 구성
    return stream(stream_db_data, content_type='text/csv')


if __name__ == "__main__":
    # 디버그 모드로 내장 웹서버 동작
    app.run(host="0.0.0.0", port=8000, debug=True)
```
