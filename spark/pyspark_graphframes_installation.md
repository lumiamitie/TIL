# GraphFrames Installation in pyspark

다음과 같은 환경에서 진행하였다

- **Python** 3.6.5 (Anaconda)
- **GraphFrames** 0.6.0
- **Spark** 2.3.2

그냥 pip을 통해 설치해보았다.

```python
# 0.6.0이 설치되었다
pip install graphframes
```

import까지는 잘 되었는데, 실행했더니 에러가 발생했다.

```python
g = gf.GraphFrame(v = vertices, e = edges)
# Py4JJavaError: An error occurred while calling o367.loadClass.
# : java.lang.ClassNotFoundException: org.graphframes.GraphFramePythonAPI
```

무언가 디펜던시가 빠진 것으로 추정된다. `pyspark --packages <graphframe_path>` 로 설치하려 했지만, proxy 옵션을 주는 방법을 찾지 못하여 실패.
다음과 같은 방법으로 우회하여 해결했다.

1. spark-shell 에서 --packages 옵션을 통해 필요한 라이브러리를 다운로드 받는다
    - `--driver-java-options` 를 통해 프록시정보를 넣고 실행시키면 `~/.ivy2/jars` 폴더 밑에 관련 jar 파일들을 다운로드 받게 된다
2. `~/.ivy2/jars` 밑에 있는 graphframes 관련 정보들을 `$SPARK_HOME/jars` 폴더 밑으로 복사한다
3. 이제 pyspark에서 graphframes를 사용할 수 있다!

```sh
spark-shell --driver-java-options="-Dhttp.proxyHost=<proxy_host> -Dhttp.proxyPort=<proxy_port> -Dhttps.proxyHost=<proxy_host> -Dhttps.proxyPort=<proxy_port>" --packages graphframes:graphframes:0.6.0-spark2.3-s_2.11
cp ~/.ivy2/jars/* $SPARK_HOME/jars
```

* 덧
    * https://stackoverflow.com/a/36676963
    * 테스트해보지는 않았지만 왠지 될거같아서.. 0.7 버전 같은거 설치하려면 이렇게 해야되지 않을까 싶다
    * --conf 안에 spark.driver.extraJavaOptions 로 넣어보기!

```sh
pyspark --conf "spark.driver.extraJavaOptions=-Dhttp.proxyHost=<proxy_host> -Dhttp.proxyPort=<proxy_port> -Dhttps.proxyHost=<proxy_host> -Dhttps.proxyPort=<proxy_port>" --packages graphframes:graphframes:0.6.0-spark2.3-s_2.11
```
