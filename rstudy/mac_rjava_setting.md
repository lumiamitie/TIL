# Mac용 R에서 rJava + KoNLP 설치하기

## 설치 과정

### 1) Homebrew를 통해 java를 설치한다

참고 : <https://steemit.com/kr/@stunstunstun/mac-homebrew>

```
brew update
brew cask install java

java -version
# openjdk version "11.0.1" 2018-10-16
# OpenJDK Runtime Environment 18.9 (build 11.0.1+13)
# OpenJDK 64-Bit Server VM 18.9 (build 11.0.1+13, mixed mode)
```

2) KoNLP를 설치한다

```r
install.packages('KoNLP')
```

## 에러?!

그런데 코드를 실행시키니 다음과 같은 에러가 발생..

```r
> KoNLP::extractNoun
Error: .onLoad failed in loadNamespace() for 'rJava', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/Library/Frameworks/R.framework/Versions/3.5/Resources/library/rJava/libs/rJava.so':
  dlopen(/Library/Frameworks/R.framework/Versions/3.5/Resources/library/rJava/libs/rJava.so, 6): Library not loaded: /Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home/lib/server/libjvm.dylib
  Referenced from: /Library/Frameworks/R.framework/Versions/3.5/Resources/library/rJava/libs/rJava.so
  Reason: image not found
In addition: Warning messages:
1: In system("/usr/libexec/java_home", intern = TRUE) :
  running command '/usr/libexec/java_home' had status 1
2: In system("/usr/libexec/java_home", intern = TRUE) :
  running command '/usr/libexec/java_home' had status 1
```

다음글을 참고해서 해결해보려 했지만, 요것도 안된다. <http://prohannah.tistory.com/22>

```
sudo ln -f -s $(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib /usr/local/lib
```

뭐가 문제지..

## 문제 해결

비슷한 내용 정리해둔 사람이 있다. <https://brunch.co.kr/@thwjd9691/6>

rJava에서 `libjvm.dylib` 의 위치를 아예 이상하게 잡고 있는 것 같다

결국 다음과 같은 방식으로 해결!!

```
-- (1) R 버전의 맞는 path로 이동한다
cd /Library/Frameworks/R.framework/Versions/3.5/Resources/lib

-- (2) 심볼릭 링크 생성
ln -f -s $(/usr/libexec/java_home)/lib/server/libjvm.dylib libjvm.dylib
-- 다음과 같은 path일 수도 있다
-- ln -f -s $(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib libjvm.dylib
```

원래 목표였던 KoNLP 실행까지 성공!

```r
library('KoNLP')
KoNLP::extractNoun('안녕하세요')
# [1] "안녕" "하세"
```

음..? 결과의 상태가..?
