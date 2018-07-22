
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

# 평가

머신러닝 프로젝트에서는 평가를 잘 하는 것이 중요하다. 서로 다른 알고리즘을 비교하거나 모형을 위한 하이퍼파라미터를 선택할 수 있게 해주기 때문이다. 평가하는 과정에서 중요한 점은, 학습하지 않은 데이터에도 잘 동작할 수 있도록 모형이 일반화되었는지 확인하는 것이다. 이를 위해 **Cross Validation**이라는 기법을 사용한다. 여기서는 **holdout**이라는 간단한 방법을 써보자. 학습과정에서 임의로 추출한 데이터(20%라고 해보자)를 테스트용으로 따로 빼두고, 평가를 위해서만 사용한다. 아래 평가과정에서 측정하는 지표들은 모두 이 **test set** 데이터를 통해 측정한 것들이다.

참고로 특정한 날짜를 기준으로 학습셋과 테스트셋 데이터를 나누기도 한다. 특정 일자보다 이전의 데이터는 모두 학습에 사용하고, 이후의 데이터는 모두 평가하는데 쓴다. 미래의 사용자 행동을 예측한다면 이러한 방식을 사용해서 평가할 수도 있다.


```python
interaction_train, interaction_test = train_test_split(
    interaction_full_df,
    stratify=interaction_full_df['personId'],
    test_size=0.2,
    random_state=42
)
# interactions on Train set: 31284
# interactions on Test set: 7822
```

추천시스템에서는 일반적으로 사용하는 평가 지표가 존재한다. **Top-N 정확도**를 사용해서 모형을 측정해보자. 모형을 통해 추천한 항목들을 테스트셋에 있는 항목들과 비교해보는 것이다.

이 평가는 다음과 같이 동작한다

- 각 사용자별로 
    - 테스트셋에 있는 데이터 중 해당 사용자가 상호작용했던 상품들에 대해서
        - 1) 해당 유저가 상호작용한 적이 없는 상품 중 100개를 샘플링한다
            - 여기서는 사용자가 상호작용하지 않았는 상품에는 관심이 없다고 가정한다
            - 단순히 상품에 대해서 인지하지 못해 상호작용하지 않았을 수도 있다. 하지만 일단 이러한 가정을 유지한다
        - 2) 추천 모형을 통해 상호작용한 상품과 상호작용 없었던 100개 상품에 대해 추천 순위를 매긴다
        - 3) 이 사용자와 상품에 대한 Top-N 정확도를 계산한다
- 전체 Top-N 정확도를 종합한다

Top-N 정확도 지표 중에서 **Recall@N** 을 사용하자. 추천하려는 상품이 101개의 상품 중에서 상위 N개 안에 존재하는지 여부를 측정한 것이다. 참고로, 관련된 상품의 순서 등을 고려한 NDCG@N 이나 MAP@N 같은 다른 지표들도 존재한다. 이러한 지표들에 대해서는 다음 [문서](http://fastml.com/evaluating-recommender-systems/)를 참고해보자.


```python
# 평가 속도를 높이기 위해 personId를 기준으로 인덱스를 설정한다
interaction_full_indexed = interaction_full_df.set_index('personId')
interaction_train_indexed = interaction_train.set_index('personId')
interaction_test_indexed = interaction_test.set_index('personId')
```


```python
def get_items_interacted(person_id, interaction_df):
    interated_items = interaction_df.loc[person_id]['contentId']
    return set(interated_items if type(interated_items) == pd.Series else [interated_items])
```

```python
class ModelEvaluator:
    def __init__(self, n_non_interacted=100):
        self.EVAL_RANDOM_SAMPLE_NON_INTERACTED_ITEMS = n_non_interacted
        
    def get_non_interacted_items_sample(self, person_id, sample_size, seed=42):
        interacted_items = get_items_interacted(person_id, interaction_full_indexed)
        all_items = set(articles_df['contentId'])
        non_interacted_items = all_items - interacted_items
        
        random.seed(seed)
        non_interacted_items_sample = random.sample(non_interacted_items, sample_size)
        return set(non_interacted_items_sample)
        
    def _verify_hit_top_n(self, item_id, recommend_items, topn):
        try:
            index = next(i for i, c in enumerate(recommend_items) if c == item_id)
        except:
            index = -1
        hit = int(index in range(0, topn))
        return hit, index
    
    def evaluate_model_for_user(self, model, person_id):
        interacted_values_testset = interaction_test_indexed.loc[person_id]
        if type(interacted_values_testset['contentId']) == pd.Series:
            person_interacted_items_testset = set(interacted_values_testset['contentId'])
        else:
            person_interacted_items_testset = set([int(interacted_values_testset['contentId'])])
        
        interacted_items_count_testset = len(person_interacted_items_testset)
        
        # 특정 사용자에 대한 추천 순위 목록을 받아온다
        person_recs = model.recommend_items(
            person_id,
            items_to_ignore=get_items_interacted(person_id, interaction_train_indexed),
            topn=10000000000
        )
        
        hits_at_5_count = 0
        hits_at_10_count = 0
        
        # test셋에서 사용자가 상호작용한 모든 항목에 대해 반복한다
        for item_id in person_interacted_items_testset:
            
            # 사용자가 상호작용하지 않은 100개 항목을 샘플링한다
            non_interacted_items_sample = self.get_non_interacted_items_sample(
                person_id,
                sample_size=self.EVAL_RANDOM_SAMPLE_NON_INTERACTED_ITEMS,
                seed=item_id % (2**32)
            )
            
            # 현재 선택한 item_id(상호작용 있었던 항목)와 100개 랜덤 샘플을 합친다
            items_to_filter_recs = non_interacted_items_sample.union(set([item_id]))
            
            # 추천 결과물 중에서 현재 선택한 item_id와 100개 랜덤 샘플의 결과물로만 필터링한다
            valid_recs_df = person_recs[person_recs['contentId'].isin(items_to_filter_recs)]
            valid_recs = valid_recs_df['contentId'].values
            
            # 현재 선택한 item_id가 Top-N 추천 결과 안에 있는지 확인한다
            hit_at_5, index_at_5 = self._verify_hit_top_n(item_id, valid_recs, 5)
            hits_at_5_count += hit_at_5
            hit_at_10, index_at_10 = self._verify_hit_top_n(item_id, valid_recs, 10)
            hits_at_10_count += hit_at_10
            
        # Recall 값은 상호작용 있었던 항목들 중에서 관련없는 항목들과 섞였을 때 Top-N에 오른 항목들의 비율로 나타낼 수 있다
        recall_at_5 = hits_at_5_count / interacted_items_count_testset
        recall_at_10 = hits_at_10_count / interacted_items_count_testset
        
        person_metrics = {
            'hits@5_count': hits_at_5_count,
            'hits@10_count': hits_at_10_count,
            'interacted_count': interacted_items_count_testset,
            'recall@5': recall_at_5,
            'recall@10': recall_at_10
        }
        return person_metrics
    
    def evaluate_model(self, model):
        people_metrics = []
        for idx, person_id in enumerate(list(interaction_test_indexed.index.unique().values)):
            person_metrics = self.evaluate_model_for_user(model, person_id)
            person_metrics['_person_id'] = person_id
            people_metrics.append(person_metrics)

        print('{} users processed'.format(idx))
        
        detailed_result = (
            pd.DataFrame(people_metrics)
              .sort_values('interacted_count', ascending=False)
        )
        
        global_recall_at_5 = detailed_result['hits@5_count'].sum() / detailed_result['interacted_count'].sum()
        global_recall_at_10 = detailed_result['hits@10_count'].sum() / detailed_result['interacted_count'].sum()
        
        global_metrics = {
            'model_name': model.get_model_name(),
            'recall@5': global_recall_at_5,
            'recall@10': global_recall_at_10
        }
        
        return global_metrics, detailed_result
```


```python
model_evaluator = ModelEvaluator(n_non_interacted=100)
```

# Popularity Model

가장 기본적이면서 깨기 어려운 접근방법은 **인기도 모형**이다. 이 모형은 사실 개인화된 추천을 하지 않는다. 그냥 인기도가 높은 항목들 중에서 사용자가 선택한 적이 없는 항목들을 추천한다. 인기도는 집단지성이라고 볼 수도 있기 때문에, 대체로 많은 사람들에게 잘 동작하는 좋은 추천을 제공한다. 하지만, 일반적으로 추천시스템의 목적은 굉장히 구체적인 주제들에 대한 롱테일 항목들을 제공하는 것이기 때문에 간단한 인기도 모형에 비해 훨씬 많은 요소들을 고려할 필요가 있다.


```python
item_popularity = (interaction_full_df
 .groupby('contentId')['eventStrength'].sum()
 .sort_values(ascending=False)
 .reset_index()
)

item_popularity.head(10)
```


<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>contentId</th>
      <th>eventStrength</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-4029704725707465084</td>
      <td>457.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-2358756719610361882</td>
      <td>361.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-6783772548752091658</td>
      <td>357.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>8657408509986329668</td>
      <td>338.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-133139342397538859</td>
      <td>336.5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-8208801367848627943</td>
      <td>327.5</td>
    </tr>
    <tr>
      <th>6</th>
      <td>-6843047699859121724</td>
      <td>315.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>2581138407738454418</td>
      <td>310.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>2857117417189640073</td>
      <td>308.5</td>
    </tr>
    <tr>
      <th>9</th>
      <td>-1633984990770981161</td>
      <td>298.0</td>
    </tr>
  </tbody>
</table>
</div>


```python
class PopularityRecommender:
    
    MODEL_NAME = 'Popularity'
    
    def __init__(self, popularity_df, items_df=None):
        self.popularity_df = popularity_df
        self.items_df = items_df
        
    def get_model_name(self):
        return self.MODEL_NAME
    
    def recommend_items(self, user_id, items_to_ignore=[], topn=10, verbose=False):
        # 인기상품 중에서 사용자가 보지 않았던 상품을 추천한다
        recommendations = (
          self.popularity_df[~self.popularity_df['contentId'].isin(items_to_ignore)]
            .sort_values('eventStrength', ascending=False)
            .head(topn)
        )
        
        if verbose:
            if self.items_df is None:
                raise Exception('"items_df" is required in verbose mode')
            recommendations = (recommendations
                .merge(self.items_df, how='left', left_on='contentId', right_on='contentId')
                .loc[:, ['eventStrength', 'contentId', 'title', 'url', 'lang']]
            )
            
        return recommendations
```


```python
popularity_model = PopularityRecommender(item_popularity, articles_df)
```

위에서 정리했던 방법을 바탕으로 인기도 모형을 평가해보자. 

**Recall@5**는 0.2262를 달성했다. 상호작용이 있었던 항목 중 22.6%는 테스트셋에서 top-5 항목에 들었다는 것을 의미한다. **Recall@10**은 34.7%이다. 


```python
print('Popularity 추천 모형을 평가합니다')
pop_global_metrics, pop_detailed_results = model_evaluator.evaluate_model(popularity_model)
print('Global Metrics:\n{}'.format(pop_global_metrics))
pop_detailed_results.head(10)

# Popularity 추천 모형을 평가합니다
# 1139 users processed
# Global Metrics:
# {'model_name': 'Popularity', 'recall@5': 0.22628483763743287, 'recall@10': 0.34671439529532089}
```


<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>_person_id</th>
      <th>hits@10_count</th>
      <th>hits@5_count</th>
      <th>interacted_count</th>
      <th>recall@10</th>
      <th>recall@5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>76</th>
      <td>3609194402293569455</td>
      <td>45</td>
      <td>22</td>
      <td>192</td>
      <td>0.234375</td>
      <td>0.114583</td>
    </tr>
    <tr>
      <th>17</th>
      <td>-2626634673110551643</td>
      <td>25</td>
      <td>14</td>
      <td>134</td>
      <td>0.186567</td>
      <td>0.104478</td>
    </tr>
    <tr>
      <th>16</th>
      <td>-1032019229384696495</td>
      <td>26</td>
      <td>18</td>
      <td>130</td>
      <td>0.200000</td>
      <td>0.138462</td>
    </tr>
    <tr>
      <th>10</th>
      <td>-1443636648652872475</td>
      <td>13</td>
      <td>4</td>
      <td>117</td>
      <td>0.111111</td>
      <td>0.034188</td>
    </tr>
    <tr>
      <th>82</th>
      <td>-2979881261169775358</td>
      <td>31</td>
      <td>22</td>
      <td>88</td>
      <td>0.352273</td>
      <td>0.250000</td>
    </tr>
    <tr>
      <th>161</th>
      <td>-3596626804281480007</td>
      <td>21</td>
      <td>12</td>
      <td>80</td>
      <td>0.262500</td>
      <td>0.150000</td>
    </tr>
    <tr>
      <th>65</th>
      <td>1116121227607581999</td>
      <td>30</td>
      <td>17</td>
      <td>73</td>
      <td>0.410959</td>
      <td>0.232877</td>
    </tr>
    <tr>
      <th>81</th>
      <td>692689608292948411</td>
      <td>22</td>
      <td>15</td>
      <td>69</td>
      <td>0.318841</td>
      <td>0.217391</td>
    </tr>
    <tr>
      <th>106</th>
      <td>-9016528795238256703</td>
      <td>18</td>
      <td>14</td>
      <td>69</td>
      <td>0.260870</td>
      <td>0.202899</td>
    </tr>
    <tr>
      <th>52</th>
      <td>3636910968448833585</td>
      <td>27</td>
      <td>15</td>
      <td>68</td>
      <td>0.397059</td>
      <td>0.220588</td>
    </tr>
  </tbody>
</table>
</div>



# Content-Based Filtering Model

컨텐츠 기반의 필터링 방법은 사용자가 상호작용했던 항목의 특성을 바탕으로 유사한 항목을 추천한다. 추천 결과물은 사용자의 이전 선택에 의해 결정되기 때문에 Cold Start 문제에 비교적 잘 대응할 수 있다. 글, 신문기사, 책 등에서 추출한 텍스트를 바탕으로 특정 항목과 사용자의 특성을 정의해볼 수 있다.

여기서는 **TF-IDF**라는 간단한 방법론을 적용해보자. 이 방법을 통해 구조화되지 않은 텍스트를 벡터 구조로 변경할 수 있다. 각 단어는 벡터 내에서 위치로 표현되고, 글에서 해당 단어가 몇 번 등장했는지를 수치로 나타낸다. 이러한 방식으로 모든 글을 벡터 공간에 표현하고 각 게시물 간의 유사도를 구한다.


```python
# # stopwords 다운로드
# import nltk
# nltk.download('stopwords')

# stopwords를 제거한다
stopwords_list = stopwords.words('english') + stopwords.words('portuguese')

# 벡터의 길이는 5000, unigram과 bigram을 사용하고, stopwords를 제거하도록 학습한다
vectorizer = TfidfVectorizer(
    analyzer='word',
    ngram_range=(1, 2),
    min_df=0.003,
    max_df=0.5,
    max_features=5000,
    stop_words=stopwords_list
)

item_ids = articles_df['contentId'].tolist()
tfidf_matrix = vectorizer.fit_transform(articles_df['title'] + '' + articles_df['text'])
tfidf_feature_names = vectorizer.get_feature_names()
```


```python
tfidf_matrix
# <3047x5000 sparse matrix of type '<class 'numpy.float64'>'
#   with 638928 stored elements in Compressed Sparse Row format>
```


사용자의 특성을 모델링하기 위해, 해당 사용자가 상호작용했던 모든 항목들 특성의 평균을 계산한다. 이 때, 각 상호작용의 강도에 따라 가중치를 부여하여 평균을 구한다.


```python
def get_item_profile(item_id):
    idx = item_ids.index(item_id)
    item_profile = tfidf_matrix[idx:idx+1]
    return item_profile

def get_item_profiles(ids):
    item_profiles_list = [get_item_profile(x) for x in ids]
    item_profiles = scipy.sparse.vstack(item_profiles_list)
    return item_profiles

def build_user_profile(person_id, interaction_indexed_df):
    interaction_person_df = interaction_indexed_df.loc[person_id]
    user_item_profiles = get_item_profiles(interaction_person_df['contentId'])
    
    user_item_strengths = np.array(interaction_person_df['eventStrength']).reshape(-1, 1)
    
    # 상호작용 강도를 바탕으로 가중치를 부여하여 평균 계산한다
    user_item_strengths_weighted_avg = \
        np.sum(user_item_profiles.multiply(user_item_strengths), axis=0) /\
        np.sum(user_item_strengths)
        
    user_profile_norm = sklearn.preprocessing.normalize(user_item_strengths_weighted_avg)
    return user_profile_norm

def build_user_profiles():
    interaction_indexed_df = (interaction_full_df
        .loc[lambda d: d['contentId'].isin(articles_df['contentId'])]
        .set_index('personId')
    )
    user_profiles = {}
    
    for person_id in interaction_indexed_df.index.unique():
        user_profiles[person_id] = build_user_profile(person_id, interaction_indexed_df)
        
    return user_profiles
```


```python
user_profiles = build_user_profiles()
len(user_profiles)
# 1140
```


프로필 안쪽을 한 번 살펴보자. 길이 5000인 단위 벡터로 되어있다. 각 값들은 해당 위치의 토큰이 (unigram 또는 bigram) 사용자와 얼마나 연관성이 있는지를 나타낸다.

저자의 프로필을 살펴보면 가장 높은 연관성을 보이는 항목들이 머신러닝, 딥러닝 등이다. 결과물이 꽤 괜찮은 것으로 보인다!


```python
myprofile = user_profiles[-1479311724257856983].flatten().tolist()
pd.DataFrame(sorted(zip(tfidf_feature_names, myprofile), key=lambda x: -x[1])[:20],
             columns=['token', 'relevance'])
```




<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>token</th>
      <th>relevance</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>learning</td>
      <td>0.312070</td>
    </tr>
    <tr>
      <th>1</th>
      <td>machine learning</td>
      <td>0.269224</td>
    </tr>
    <tr>
      <th>2</th>
      <td>machine</td>
      <td>0.256997</td>
    </tr>
    <tr>
      <th>3</th>
      <td>data</td>
      <td>0.186630</td>
    </tr>
    <tr>
      <th>4</th>
      <td>google</td>
      <td>0.171385</td>
    </tr>
    <tr>
      <th>5</th>
      <td>ai</td>
      <td>0.141732</td>
    </tr>
    <tr>
      <th>6</th>
      <td>graph</td>
      <td>0.114026</td>
    </tr>
    <tr>
      <th>7</th>
      <td>algorithms</td>
      <td>0.109420</td>
    </tr>
    <tr>
      <th>8</th>
      <td>like</td>
      <td>0.096113</td>
    </tr>
    <tr>
      <th>9</th>
      <td>language</td>
      <td>0.085010</td>
    </tr>
    <tr>
      <th>10</th>
      <td>models</td>
      <td>0.081785</td>
    </tr>
    <tr>
      <th>11</th>
      <td>search</td>
      <td>0.081096</td>
    </tr>
    <tr>
      <th>12</th>
      <td>algorithm</td>
      <td>0.076943</td>
    </tr>
    <tr>
      <th>13</th>
      <td>people</td>
      <td>0.076800</td>
    </tr>
    <tr>
      <th>14</th>
      <td>deep learning</td>
      <td>0.076610</td>
    </tr>
    <tr>
      <th>15</th>
      <td>research</td>
      <td>0.073528</td>
    </tr>
    <tr>
      <th>16</th>
      <td>spark</td>
      <td>0.073341</td>
    </tr>
    <tr>
      <th>17</th>
      <td>deep</td>
      <td>0.072905</td>
    </tr>
    <tr>
      <th>18</th>
      <td>company</td>
      <td>0.069137</td>
    </tr>
    <tr>
      <th>19</th>
      <td>model</td>
      <td>0.067404</td>
    </tr>
  </tbody>
</table>
</div>


```python
class ContentBasedRecommender:
    
    MODEL_NAME = 'Content-Based'
    
    def __init__(self, item_ids, items_df=None):
        self.item_ids = item_ids
        self.items_df = items_df
        
    def get_model_name(self):
        return self.MODEL_NAME
    
    def _get_similar_items_to_user_profile(self, person_id, topn=1000):
        # 유저 특성과 항목 특성 사이의 코사인 유사도를 구한다
        cosine_similarities = cosine_similarity(user_profiles[person_id], tfidf_matrix)
        
        # 가장 유사한 항목을 찾는다
        similar_indices = cosine_similarities.argsort().flatten()[-topn:]
        
        # 유사도를 기준으로 유사한 항목을 정렬한다
        similar_items = sorted(
            [(item_ids[i], cosine_similarities[0, i]) for i in similar_indices],
            key=lambda x: -x[1]
        )
        
        return similar_items
    
    def recommend_items(self, user_id, items_to_ignore=[], topn=10, verbose=False):
        similar_items = self._get_similar_items_to_user_profile(user_id)
        
        # 기존에 상호작용했던 항목은 제거한다
        similar_items_filtered = list(filter(lambda x: x[0] not in items_to_ignore, similar_items))
        
        recommendations = (
            pd.DataFrame(similar_items_filtered, columns=['contentId', 'recStrength'])
              .head(topn)
        )
        
        if verbose:
            if self.items_df is None:
                raise Exception('"items_df" is required in verbose mode')
            recommendations = (recommendations
                .merge(self.items_df, how='left', left_on='contentId', right_on='contentId')
                .loc[:, ['recStrength', 'contentId', 'title', 'url', 'lang']]
            )
        
        return recommendations
```


```python
content_based_model = ContentBasedRecommender(item_ids, articles_df)
```

콘텐츠 기반 추천 모형을 통해 개인화된 추천을 테스트해본 결과, **Recall@5**는 0.3842, **Recall@10**은 0.4941로 증가한 것을 볼 수 있다. 


```python
print('콘텐츠 기반 추천 모형을 평가합니다')
cb_global_metrics, cb_detailed_results = model_evaluator.evaluate_model(content_based_model)
print('Global Metrics:\n{}'.format(cb_global_metrics))
cb_detailed_results.head(10)

# 콘텐츠 기반 추천 모형을 평가합니다
# 1139 users processed
# Global Metrics:
# {'model_name': 'Content-Based', 'recall@5': 0.38417284581948352, 'recall@10': 0.49411915111224752}
```

<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>_person_id</th>
      <th>hits@10_count</th>
      <th>hits@5_count</th>
      <th>interacted_count</th>
      <th>recall@10</th>
      <th>recall@5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>76</th>
      <td>3609194402293569455</td>
      <td>29</td>
      <td>17</td>
      <td>192</td>
      <td>0.151042</td>
      <td>0.088542</td>
    </tr>
    <tr>
      <th>17</th>
      <td>-2626634673110551643</td>
      <td>36</td>
      <td>19</td>
      <td>134</td>
      <td>0.268657</td>
      <td>0.141791</td>
    </tr>
    <tr>
      <th>16</th>
      <td>-1032019229384696495</td>
      <td>35</td>
      <td>20</td>
      <td>130</td>
      <td>0.269231</td>
      <td>0.153846</td>
    </tr>
    <tr>
      <th>10</th>
      <td>-1443636648652872475</td>
      <td>47</td>
      <td>33</td>
      <td>117</td>
      <td>0.401709</td>
      <td>0.282051</td>
    </tr>
    <tr>
      <th>82</th>
      <td>-2979881261169775358</td>
      <td>20</td>
      <td>6</td>
      <td>88</td>
      <td>0.227273</td>
      <td>0.068182</td>
    </tr>
    <tr>
      <th>161</th>
      <td>-3596626804281480007</td>
      <td>26</td>
      <td>17</td>
      <td>80</td>
      <td>0.325000</td>
      <td>0.212500</td>
    </tr>
    <tr>
      <th>65</th>
      <td>1116121227607581999</td>
      <td>17</td>
      <td>13</td>
      <td>73</td>
      <td>0.232877</td>
      <td>0.178082</td>
    </tr>
    <tr>
      <th>81</th>
      <td>692689608292948411</td>
      <td>19</td>
      <td>14</td>
      <td>69</td>
      <td>0.275362</td>
      <td>0.202899</td>
    </tr>
    <tr>
      <th>106</th>
      <td>-9016528795238256703</td>
      <td>15</td>
      <td>9</td>
      <td>69</td>
      <td>0.217391</td>
      <td>0.130435</td>
    </tr>
    <tr>
      <th>52</th>
      <td>3636910968448833585</td>
      <td>13</td>
      <td>4</td>
      <td>68</td>
      <td>0.191176</td>
      <td>0.058824</td>
    </tr>
  </tbody>
</table>
</div>

