# 구글 Colab에서 CausalNex 튜토리얼 실행시켜보기

## 설치 및 데이터 다운로드

- 2020-04-01 기준 causalnex 0.5 버전을 설치하면 강제로 pandas 0.24.0 을 다운로드 한다
- causalnex의 다른 디펜던시 및 google-colab 관련 라이브러리들이 pandas 0.25 이상을 필요로 하기 때문에 pandas를 새로 설치한다

```
!pip install causalnex
!pip install 'pandas==1.0.0' --force-reinstall
```

- pygraphviz 를 설치하기 위해 관련된 디펜던시를 설치한다
    - `graphviz-dev` 를 설치하지 않을 경우 pygraphviz 라이브러리 설치가 실패한다
    - 참고. <https://github.com/pygraphviz/pygraphviz/issues/163>

```
!apt-get install -y graphviz-dev
!pip install pygraphviz
```

- 예제 데이터를 다운로드 한다

```
!wget https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip && unzip student.zip
```
