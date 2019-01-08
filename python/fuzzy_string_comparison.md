# Fuzzy String Comparison

```python
from fuzzywuzzy import fuzz, process      # pip install fuzzywuzzy
from difflib import SequenceMatcher as SM # Standard Library

SM(None, '안녕하세요', '안녕하세요?').ratio()
# 0.9090909090909091
fuzz.ratio('안녕하세요', '안녕하세요?')
# 91

SM(None, 'account_id', 'accountId').ratio()
# 0.8421052631578947
fuzz.ratio('account_id', 'accountId')
# 84

fuzz.token_sort_ratio('account_id', 'accountId')
# 95

fuzz.token_set_ratio('account_id', 'accountId')
# 95
```
TODO : `token_sort_ratio`, `token_set_ratio` 는 뭐지?
