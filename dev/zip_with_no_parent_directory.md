# zip 명령어로 압축할 때 폴더구조로 저장하기 않도록 설정하기

## 문제상황

- 다음과 같은 상황에서 zip 명령어를 통해 ttf 파일을 압축하려고 한다
- zip 명령어로 그냥 압축을 했더니, ttf 파일들이 목표 지점에 생성되지 않고 `font/` 디렉토리 밑에 생성된다
- 불필요한 부모 폴더없이 압축할 수 있는 방법이 없을까?

```
Downloads
ㄴ font/
    ㄴ font1.ttf
    ㄴ font2.ttf
    ㄴ fonts3.ttf
```

## 해결방법

- `-j` 옵션을 사용한다 (`--junk-paths`)

```
cd ~/Downloads/font
zip fonts.zip -j ./*

# 이제 압축을 풀었을 때 디렉토리가 아니라 파일로 바로 풀린다
unzip fonts.zip -d ~/Downloads
```

# 참고자료

- [Askubuntu: Zip an archive without including parent directory](https://askubuntu.com/a/940754)
