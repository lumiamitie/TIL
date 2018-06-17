# Matplotlib에서 사용할 수 있는 폰트 목록 확인하기

matplotlib에서 사용할 수 있는 폰트 목록을 조회하려면 어떻게 해야 할까?

## 1) 폰트 파일만 확인하기

`matplotlib.font_manager.findSystemFonts()` 를 통해 시스템에 등록된 폰트파일을 조회할 수 있다

```python
import matplotlib
matplotlib.font_manager.findSystemFonts()

# ['/Library/Fonts/STIXIntUpBol.otf',
#  '/opt/X11/share/fonts/OTF/SyrCOMJerusalemItalic.otf',
#  '/usr/X11/lib/X11/fonts/TTF/VeraMono.ttf',
#  '/Library/Fonts/Luminari.ttf',
#  '/System/Library/Fonts/SFCompactDisplay-Ultralight.otf',
# ....
# ]
```

## 2) 폰트 이름 목록 확인하기

다음 함수를 통해 폰트 이름을 가져올 수 있다

```python
def get_font_names():
    font_list = matplotlib.font_manager.get_fontconfig_fonts()
    
    def safe_get_font_name(fname):
        try:
            return matplotlib.font_manager.FontProperties(fname=fname).get_name()
        except:
            return None
    
    font_names = [safe_get_font_name(fname) for fname in font_list]
    filtered_names = [fname for fname in list(set(font_names))
                      if fname is not None]
    return filtered_names

# ['.LastResort',
#  'STIXVariants',
#  'Estrangelo Antioch',
#  'STIXIntegralsUp',
#  'STIXSizeFiveSym',
#  'Bitstream Vera Sans Mono',
#  'Impact',
#  '.SF Compact Rounded',
#  'Sathu',
#  'STIXSizeTwoSym',
#  'Zapfino',
#  'System Font',
#  'Kakao',
#  ......
# ]
```
