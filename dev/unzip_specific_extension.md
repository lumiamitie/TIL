# unzip 명령어로 특정 확장자를 가진 파일만 압축 해제하기

## 문제상황

- 폰트가 담겨있는 zip 파일을 unzip 명령어를 사용해 폰트 파일만 압축 해제하려고 한다
- 압축을 어딘가에 풀어놓고 특정 파일만 옮기는 대신, **원하는 확장자를 가진 파일만 압축을 해제하려면 어떻게 해야 할까?**

## 해결방법

- unzip 명령을 사용할 때, wildcard 문자열을 통해 원하는 확장자를 지정하면 된다
- ttf 또는 otf 파일만 압축 해제하려면 다음과 같이 입력한다

```bash
unzip file_to_unzip.zip "*.ttf" "*.otf" -d path/to/unzip/

# (1) otf 파일과 txt 파일만 들어있는 Noto Sans 압축파일
unzip Noto_Sans_KR.zip "*.ttf" "*.otf" -d /tmp
# Archive:  Noto_Sans_KR.zip
#   inflating: /tmp/NotoSansKR-Thin.otf
#   inflating: /tmp/NotoSansKR-Light.otf
#   inflating: /tmp/NotoSansKR-Regular.otf
#   inflating: /tmp/NotoSansKR-Medium.otf
#   inflating: /tmp/NotoSansKR-Bold.otf
#   inflating: /tmp/NotoSansKR-Black.otf
# caution: filename not matched:  *.ttf

# (2) txt, ttf, woff, woff2 파일이 들어있는 Spoqa Han Sans 압축파일
unzip SpoqaHanSans_subset.zip "*.ttf" "*.otf" -d /tmp
# Archive:  SpoqaHanSans_subset.zip
#   inflating: /tmp/SpoqaHanSans_subset/SpoqaHanSansRegular.ttf
#   inflating: /tmp/SpoqaHanSans_subset/SpoqaHanSansThin.ttf
#   inflating: /tmp/SpoqaHanSans_subset/SpoqaHanSansLight.ttf
#   inflating: /tmp/SpoqaHanSans_subset/SpoqaHanSansBold.ttf
# caution: filename not matched:  *.otf
```

위 예제에서처럼 `caution: filename not matched` 가 발생하는 경우 평소 사용에는 문제가 없지만, 도커 이미지를 빌드하는 과정에서 발생할 경우 작업이 실패 처리될 수 있다.

# 참고자료

- [StackOverflow Answer | unzip specific extension only](https://stackoverflow.com/a/36191855)
