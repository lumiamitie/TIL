
다음 문서를 정리한다 : [Kaggle - Recommender Systems in Python 101](https://www.kaggle.com/gspmoreira/recommender-systems-in-python-101)

---

# Recommender Systems in Python 101

추천 시스템을 위한 기본적인 기법들에 대해 알아보자. 추천 시스템의 목적은 유저의 선호도를 바탕으로 관련있는 항목을 추천해주는 것이다. 여기서 선호와 관련성은 주관적이며, 보통은 해당 사용자가 이전에 소비했던 항목들을 바탕으로 추론한다. 

추천 시스템의 주요 기법들은 다음과 같다

- **Collaborative Filtering**
    - 다수의 사용자를 통해 얻어낸 상품 선호 정보를 바탕으로 특정한 사용자의 관심사를 예측한다
    - 협업 필터링은 유저 A와 B가 특정 상품에 대해 동일한 의견을 가지고 있다면, A는 주어진 상품에 대해서 임의의 다른 유저보다 B와 유사한 의견을 가질 것이라는 것을 가정한다
- **Content-Based Filtering**
    - 이 방법은 사용자가 소비했던 상품의 정보와 속성만을 이용한다
    - 다시 말해, 과거에 소비했던 상품과 유사한 속성을 가진 상품을 추천한다
    - 다양한 후보 상품들을 구하고, 사용자가 이전에 평가했던 상품들과 비교해서 가장 잘 맞는 상품을 추천한다
- **Hybrid Methods**
    - 최근의 연구들은 협업 필터링과 컨텐츠 기반 필터링을 조합하여 높은 성과를 거두었다
    - 기존의 방식에서 종종 발생하는 cold start 문제나 sparcity 문제를 해결하는데 도움이 될 수 있다

캐글 데이터셋인 [Articles Sharing and Reading from CI&T Deskdrop](https://www.kaggle.com/gspmoreira/articles-sharing-reading-from-cit-deskdrop) 데이터를 가지고 실습해보자. Collaborative Filtering, Content-Based Filtering, Hybrid methods를 파이썬으로 구현해 볼 것이다.


```python
import numpy as np
import scipy
import pandas as pd
import math
import random
import sklearn
from nltk.corpus import stopwords
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from scipy.sparse.linalg import svds
import matplotlib.pyplot as plt
```

# 데이터 불러오기 : CI&T Deskdrop 데이터

Deskdrop 데이터는 12달간의 실제 데이터를 담고 있다. 사용자 인터랙션 정보가 7만3천건 정도, 플랫폼 내에서 공유된 게시물 정보가 3천건 정도 존재한다.

## 공유된 게시물 정보


```python
articles_df = (
  pd.read_csv('data_recsys_in_python_101/shared_articles.csv')
    .loc[lambda d: d['eventType'] == 'CONTENT SHARED']  
)
```


```python
articles_df.head(5)
```

<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>eventType</th>
      <th>contentId</th>
      <th>authorPersonId</th>
      <th>authorSessionId</th>
      <th>authorUserAgent</th>
      <th>authorRegion</th>
      <th>authorCountry</th>
      <th>contentType</th>
      <th>url</th>
      <th>title</th>
      <th>text</th>
      <th>lang</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>1459193988</td>
      <td>CONTENT SHARED</td>
      <td>-4110354420726924665</td>
      <td>4340306774493623681</td>
      <td>8940341205206233829</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>HTML</td>
      <td>http://www.nytimes.com/2016/03/28/business/dea...</td>
      <td>Ethereum, a Virtual Currency, Enables Transact...</td>
      <td>All of this work is still very early. The firs...</td>
      <td>en</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1459194146</td>
      <td>CONTENT SHARED</td>
      <td>-7292285110016212249</td>
      <td>4340306774493623681</td>
      <td>8940341205206233829</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>HTML</td>
      <td>http://cointelegraph.com/news/bitcoin-future-w...</td>
      <td>Bitcoin Future: When GBPcoin of Branson Wins O...</td>
      <td>The alarm clock wakes me at 8:00 with stream o...</td>
      <td>en</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1459194474</td>
      <td>CONTENT SHARED</td>
      <td>-6151852268067518688</td>
      <td>3891637997717104548</td>
      <td>-1457532940883382585</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>HTML</td>
      <td>https://cloudplatform.googleblog.com/2016/03/G...</td>
      <td>Google Data Center 360° Tour</td>
      <td>We're excited to share the Google Data Center ...</td>
      <td>en</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1459194497</td>
      <td>CONTENT SHARED</td>
      <td>2448026894306402386</td>
      <td>4340306774493623681</td>
      <td>8940341205206233829</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>HTML</td>
      <td>https://bitcoinmagazine.com/articles/ibm-wants...</td>
      <td>IBM Wants to "Evolve the Internet" With Blockc...</td>
      <td>The Aite Group projects the blockchain market ...</td>
      <td>en</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1459194522</td>
      <td>CONTENT SHARED</td>
      <td>-2826566343807132236</td>
      <td>4340306774493623681</td>
      <td>8940341205206233829</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>HTML</td>
      <td>http://www.coindesk.com/ieee-blockchain-oxford...</td>
      <td>IEEE to Talk Blockchain at Cloud Computing Oxf...</td>
      <td>One of the largest and oldest organizations fo...</td>
      <td>en</td>
    </tr>
  </tbody>
</table>
</div>


## 사용자 인터랙션 정보

공유된 게시물 정보와 사용자 인터렉션 정보는 `contentId` 값을 통해 조인될 수 있다.


```python
interaction_df = pd.read_csv('data_recsys_in_python_101/users_interactions.csv')
```


```python
interaction_df.head(5)
```


<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>eventType</th>
      <th>contentId</th>
      <th>personId</th>
      <th>sessionId</th>
      <th>userAgent</th>
      <th>userRegion</th>
      <th>userCountry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1465413032</td>
      <td>VIEW</td>
      <td>-3499919498720038879</td>
      <td>-8845298781299428018</td>
      <td>1264196770339959068</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1465412560</td>
      <td>VIEW</td>
      <td>8890720798209849691</td>
      <td>-1032019229384696495</td>
      <td>3621737643587579081</td>
      <td>Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2...</td>
      <td>NY</td>
      <td>US</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1465416190</td>
      <td>VIEW</td>
      <td>310515487419366995</td>
      <td>-1130272294246983140</td>
      <td>2631864456530402479</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1465413895</td>
      <td>FOLLOW</td>
      <td>310515487419366995</td>
      <td>344280948527967603</td>
      <td>-3167637573980064150</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1465412290</td>
      <td>VIEW</td>
      <td>-7820640624231356730</td>
      <td>-445337111692715325</td>
      <td>5611481178424124714</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>


## 데이터 전처리

인터렉션의 종류는 여러 가지가 있기 때문에, 각 액션에 대한 가중치 또는 강도를 가정해볼 수 있다. 예를 들면, 아티클에 댓글을 하나 달았을 경우 단순히 좋아요를 누르거나 게시물을 보기만 한 것보다 더 관심이 있다고 생각할 수 있다.


```python
event_type_strength = {
   'VIEW': 1.0,
   'LIKE': 2.0, 
   'BOOKMARK': 2.5, 
   'FOLLOW': 3.0,
   'COMMENT CREATED': 4.0,  
}

interaction_df['eventStrength'] = (
  interaction_df
    .loc[:, 'eventType']
    .apply(lambda d: event_type_strength[d])
)
```

추천 시스템에서는 사용자에 대한 정보가 부족할 때 추천을 제공하기가 어려워지는 **Cold Start** 문제가 존재한다. 이러한 이유로 5개 이상의 인터렉션이 존재하는 사용자에 대한 데이터만 활용하도록 한다.


```python
interaction_df_over5 = (interaction_df
  .groupby('personId', group_keys=False)
  .apply(lambda df: df.assign(interactCnt = lambda d: d['contentId'].nunique()))
  .loc[lambda d: d['interactCnt'] >= 5]
)
```

```python
# 인터렉션수 5 이상인 사용자의 데이터는 69868건
interaction_df_over5.shape[0]
```

Deskdrop에서는 사용자들이 특정한 아티클을 여러번 볼 수 있고, 좋아요나 댓글 등 다양한 상호작용을 할 수 있다. 따라서 특정한 아티클에 대한 사용자의 선호도를 알기 위해, 모든 상호작용에 대한 점수를 합산하고 로그변환을 통해 분포를 평활하게 만든다.


```python
interaction_full_df = (
  interaction_df_over5
    .groupby(['personId', 'contentId'], as_index=False)['eventStrength']
    .sum()
    .assign(eventScore = lambda d: np.log2(1+d['eventStrength']))
)

interaction_full_df.head(10)
```


<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>personId</th>
      <th>contentId</th>
      <th>eventStrength</th>
      <th>eventScore</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-9223121837663643404</td>
      <td>-8949113594875411859</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-9223121837663643404</td>
      <td>-8377626164558006982</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-9223121837663643404</td>
      <td>-8208801367848627943</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-9223121837663643404</td>
      <td>-8187220755213888616</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-9223121837663643404</td>
      <td>-7423191370472335463</td>
      <td>8.0</td>
      <td>3.169925</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-9223121837663643404</td>
      <td>-7331393944609614247</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>-9223121837663643404</td>
      <td>-6872546942144599345</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>-9223121837663643404</td>
      <td>-6728844082024523434</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>-9223121837663643404</td>
      <td>-6590819806697898649</td>
      <td>1.0</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>9</th>
      <td>-9223121837663643404</td>
      <td>-6558712014192834002</td>
      <td>2.0</td>
      <td>1.584963</td>
    </tr>
  </tbody>
</table>
</div>


