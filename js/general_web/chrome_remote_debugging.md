# 맥에서 안드로이드 모바일 크롬 원격 디버깅하기

## USB 디버깅 연결하기

### adb 설치

- 우선 adb를 설치해야한다 (homebrew를 통해 설치한다)

```shell
# android-platform-tools 를 설치한다
brew cask install android-platform-tools
```

- 설치 후 명령어를 실행시켜보면 Undefined Developers 에러가 발생하며 실행되지 않는다
    - 애플의 보안 정책으로 인해 확인되지 않은 프로그램의 실행이 제한된다
- Finder에서 직접 실행해서 권한을 열어주어야 한다
    - `adb`가 설치된 경로를 Finder로 실행한다 : `open /usr/local/bin`
    - `adb` 를 오른쪽 클릭 후 열기를 누르면 **실행 여부를 허용**할 수 있다
- 이제 adb를 실행할 수 있다!
    - 쉘에서 다음 명령어를 입력한다

```shell
adb devices

# * daemon not running; starting now at tcp:5037
# * daemon started successfully
# List of devices attached
# LMX415Sa84d692	unauthorized
```

- 명령어를 입력하면 핸드폰에 USB 원격 디버깅을 허용할지 여부를 묻는 창이 뜬다
    - 확인 버튼을 누른다

### 크롬 개발자 도구

- 크롬에서 `chrome://inspect/#devices` 로 진입한다
- 이제 Devices 탭에서 연결된 핸드폰의 정보를 확인할 수 있다
- 모바일에서 크롬을 켜면 디바이스 및에 페이지 목록이 뜨는데, 여기서 inspect 버튼을 누르면 개발자 도구 화면이 뜬다

# 참고자료

- [Get Started with Remote Debugging Android Devices](https://developers.google.com/web/tools/chrome-devtools/remote-debugging?hl=ko)
- [android - MAC OS X에 ADB 설치하기 - 코드 로그](https://codeday.me/ko/qa/20190306/8902.html)
- [Android Debug Bridge (adb) | Android Developers](https://developer.android.com/studio/command-line/adb?hl=ko)
- [Homebrew/homebrew-cask](https://github.com/Homebrew/homebrew-cask/blob/master/doc/faq/the_app_cant_be_opened.md)
