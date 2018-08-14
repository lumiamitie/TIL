# How to use Google Cloud NLP in R

```r
library('tidyverse')
library('googleLanguageR')

# 서비스 계정 키 적용
gl_auth('path/to/service/account/key.json')

# Entity
sample_entity_result = gl_nlp(
  string = sample_full_text, 
  nlp_type = 'analyzeEntities', 
  type = 'PLAIN_TEXT', 
  language = 'ko',
  encodingType = 'UTF8'
)

# Syntax
sample_syntax_result = gl_nlp(
  string = sample_full_text, 
  nlp_type = 'analyzeSyntax',
  type = 'PLAIN_TEXT', 
  language = 'ko',
  encodingType = 'UTF8'
)
```