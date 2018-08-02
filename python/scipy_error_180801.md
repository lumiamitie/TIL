# Scipy 에러 해결하기

## 문제상황

`scipy.sparse.linalg.svds` 를 사용해서 svd를 수행하려고 한다

데이터의 형태는 다음과 같다

```python
df_eid_word_pivot.shape
# (7814, 1732)

df_eid_word_pivot.values
# array([[0, 0, 0, ..., 0, 0, 0],
#        [0, 0, 0, ..., 0, 0, 0],
#        [0, 0, 0, ..., 0, 0, 0],
#        ..., 
#        [0, 0, 0, ..., 0, 0, 0],
#        [0, 0, 0, ..., 0, 0, 0],
#        [0, 0, 0, ..., 0, 0, 0]])
```

다음과 같이 svds를 수행하면 에러가 발생한다

```python
U, sigma, Vt = svds(df_eid_word_pivot.as_matrix(), k=15)
# ValueError: matrix type must be 'f', 'd', 'F', or 'D'
```

## 해결방법

- 값들이 int로 들어가있어서 생기는 문제
- float 등으로 변환해주면 된다
- 참고. <https://stackoverflow.com/questions/8650014/sparse-matrix-valueerror-matrix-type-must-be-f-d-f-or-d>

```python
df_eid_word_pivot = (df_eid_word
  .loc[lambda d: d['word'].isin(df_wordcounts.loc[lambda d: d['cnt']>10]['word'].values)]
  .assign(cnt = lambda d: d['cnt'].astype(float))
  .reset_index()
  .drop(columns='index')
  .pivot(index='eid', columns='word', values='cnt')
  .fillna(0)
)

U, sigma, Vt = svds(df_eid_word_pivot.as_matrix(), k=15)
```
