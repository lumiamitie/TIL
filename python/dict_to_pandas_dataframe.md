
# 파이썬 딕셔너리를 pandas dataframe으로 변환하기


```python
import pandas as pd
```

다음과 같은 형태로 구성된 dictionary를 pd.DataFrame으로 변환해보자


```python
test_dict = {
    'word1': 1,
    'word2': 2,
    'word3': 3,
    'word4': 4,
    'word5': 5
}
```

## 방법1


```python
(pd.DataFrame
  .from_dict(test_dict, orient='index')
  .reset_index()
  .rename(columns={'index': 'col_name_for_key', 0: 'col_name_for_value'})
)
```


<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>col_name_for_key</th>
      <th>col_name_for_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>word1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>word2</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>word3</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>word4</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>word5</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>



## 방법2


```python
pd.DataFrame(list(test_dict.items()), 
             columns=['col_name_for_key', 'col_name_for_value'])
```


<div>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>col_name_for_key</th>
      <th>col_name_for_value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>word1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>word2</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>word3</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>word4</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>word5</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>


