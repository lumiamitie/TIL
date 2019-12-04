# Pandas DataFrame에 들어있는 이미지 URL 렌더링하기

jupyter 환경에서 DataFrame 내에 이미지 URL이 값으로 들어가 있을 때 URL 대신 이미지로 바로 살펴볼 수 없을까?

다음과 같은 함수를 구현하여 실행한다.

```python
import pandas as pd
from IPython.display import display, Image, HTML

def display_w_image(dataframe, image_cols=[]):
    path_to_html = lambda path: '<img src="{}" style="max-width: 200px;" />'.format(path)
    with pd.option_context('display.max_colwidth', 100):
        image_formatter_target = {}
        for col in image_cols:
            image_formatter_target[col] = path_to_html
        display(HTML(dataframe.to_html(escape=False, formatters=image_formatter_target)))

# image_url 컬럼의 URL을 이미지로 변환한다
# - target_df 는 pandas.DataFrame 객체
# - 'image_url' 이라는 컬럼에 이미지 path가 string으로 들어가 있는 상황을 가정한다
display_w_image(target_df, image_cols=['image_url'])

# 또는 pd.DataFrame.pipe() 를 사용해 다음과 같이 실행한다
target_df.pipe(display_w_image, image_cols=['image_url'])
```

# 참고자료

- [Include and display an Image in a dataframe](https://stackoverflow.com/questions/37365824/pandas-ipython-notebook-include-and-display-an-image-in-a-dataframe)
- [Display Images Inside Pandas Dataframe](https://datascience.stackexchange.com/questions/38083/display-images-url-inside-pandas-dataframe)
