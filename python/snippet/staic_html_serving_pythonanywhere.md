# PythonAnywhere 에서 static html 파일 서빙하기

간단한 html, js 파일로만 구성된 static HTML 문서를 서빙하는 방법에 대해 정리한다. 

- Flask 웹앱을 생성한다
- 원하는 html 파일을 `~/static` 폴더에 넣어둔다
    - mkdir로 static 디렉토리를 생성
- 기본적으로 생성되어 있는 `~/mysite/flask_app.py` 파일을 열어서 `/` 가 아닌 다른 곳으로 라우팅시킨다

```python
from flask import Flask

app = Flask(__name__, static_url_path='')

@app.route('/aa')
def hello_world():
    return 'Hello world'
```

- Static Files에 다음과 같이 추가한다
    - URL : `/`
    - Directory : `~/static`

완료되었다면 웹앱을 리로드한다! 그러면 이제 `<id>.pythonanywhere.com` 으로 접속할 수 있다.
