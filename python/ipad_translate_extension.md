# 아이패드에서 구글 번역 익스텐션 만들기

아마존 킨들 어플에서는 bing API를 통해 번역 기능을 제공한다.
그런데 이 API의 영한 번역 품질이 너무 별로라서, pythonista 어플을 통해 **구글번역을 사용할 수 있는 익스텐션** 을 추가해보기로 했다.

# 준비과정

- 우선 ipad에 pythonista 최신버전이 설치되어 있어야 한다
- pypi의 라이브러리를 설치하기 위해 [StaSh](https://github.com/ywangd/stash) 를 설치한다
- python3 로 stash를 실행시키고 pip로 [googletrans](https://github.com/ssut/py-googletrans) 를 설치한다

# 스크립트 작성

- `New > Text Extension` 을 선택하면 텍스트를 다루기 위한 샘플 익스텐션 스크립트가 생성된다
- 파일명을 결정하고, 스크립트를 다음과 같이 수정한다

```python
import appex
import clipboard
from googletrans import Translator

def main():
    if not appex.is_running_extension():
        print('Running in Pythonista app, using test data...\n')
        text = 'Lorem ipsum dolor sit amet'
    else:
        # Extension을 통해 실행되었다면 블록 설정한 텍스트를 가져온다
        text = appex.get_text()
    if text:
        print('Input text: %s' % text)
        # 입력받은 텍스트를 한글로 번역하고 결과를 반환한다
        translation = Translator().translate(text, dest='ko')
        print('Translation : %s' % translation.text)
    else:
        print('No input text found.')

if __name__ == '__main__':
    main()
```

# 익스텐션 등록하기

- 이제 방금 만든 스크립트를 Share에서 사용할 수 있도록 등록해야 한다
- `Settings > Share Extension Shortcuts` 를 선택한다
- `+` 버튼을 눌러서 작성한 스크립트를 추가한다

이제 구글번역 익스텐션을 사용할 수 있다!!

# 익스텐션 사용하기

1. 임의의 어플에서 텍스트 블록 지정
2. Share (공유) 항목 선택
3. Run Pythonista Script 선택
4. 방금 만든 익스텐션 선택

| Kindle 기본제공 번역 기능 | Translate Extension |
|:-------------------------:|:-------------------:|
|![](fig/ipad_translate_extension/ipad_translate_extension_01.png)|![](fig/ipad_translate_extension/ipad_translate_extension_02.png)|
