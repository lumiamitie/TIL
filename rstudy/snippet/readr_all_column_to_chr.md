# R readr 에서 데이터 불러올 때 전체 컬럼의 타입을 하나로 강제해서 불러오기

## 문제상황

- tsv 파일을 데이터프레임 형태로 파싱하는데, 상당히 많은 파싱 오류가 발생했다
- 데이터프레임은 생성되었지만 오류가 발생한 항목들은 모두 값이 빈 상태로 들어왔다는 것을 확인했다

```r
library(readr)
canvass_data_url <- 'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
canvass_typeguess <- read_tsv(canvass_data_url)
# Warning: 77691 parsing failures.
#   row                col           expected actual                                                                                                        file
# 66554 vf_party           1/0/T/F/TRUE/FALSE     N  'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
# 66554 therm_obama_t0     1/0/T/F/TRUE/FALSE     75 'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
# 66554 therm_gay_t0       1/0/T/F/TRUE/FALSE     50 'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
# 66554 therm_trans_t0     1/0/T/F/TRUE/FALSE     50 'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
# 66554 therm_marijuana_t0 1/0/T/F/TRUE/FALSE     60 'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
# ..... ................ [... truncated]
```

- 전체 데이터를 살펴보면 다음과 같다
- `complete_rate=0` 인 컬럼에는 값이 아예 들어오지 않았다는 것을 확인할 수 있다

```r
skimr::skim(canvass_typeguess)

# ── Data Summary ────────────────────────
#                            Values           
# Name                       canvass_typeguess
# Number of rows             68378            
# Number of columns          120              
# _______________________                     
# Column type frequency:                      
#   character                1                
#   logical                  107              
#   numeric                  12               
# ________________________                    
# Group variables            None             
# 
# ── Variable type: character ────────────────────────────────────────────────────────────────────────
#   skim_variable n_missing complete_rate   min   max empty n_unique whitespace
# 1 vf_racename           0             1     5    16     0        7          0
# 
# ── Variable type: logical ──────────────────────────────────────────────────────────────────────────
#     skim_variable                    n_missing complete_rate     mean count               
#   1 vf_party                             68378     0         NaN      ": "                
#   2 miami_trans_law_t0                   67945     0.00633     0.321  "FAL: 294, TRU: 139"
#   3 miami_trans_law2_t0                  67913     0.00680     0.357  "FAL: 299, TRU: 166"
#   4 gender_norm_daugher_t0               67486     0.0130      0.478  "FAL: 466, TRU: 426"
#   5 gender_norm_looks_t0                 67486     0.0130      0.459  "FAL: 483, TRU: 409"
#   6 gender_norm_rights_t0                67385     0.0145      0.531  "TRU: 527, FAL: 466"
#   7 gender_norms_sexchange_t0            67321     0.0155      0.457  "FAL: 574, TRU: 483"
#   8 gender_norms_moral_t0                67517     0.0126      0.307  "FAL: 597, TRU: 264"
#   9 gender_norms_abnormal_t0             67473     0.0132      0.323  "FAL: 613, TRU: 292"
#  10 gender_norm_trans_moral_wrong_t0     67927     0.00660     0.282  "FAL: 324, TRU: 127"
#  11 ssm_t0                               67913     0.00680     0.249  "FAL: 349, TRU: 116"
#  12 therm_obama_t0                       68152     0.00331     0.0265 "FAL: 220, TRU: 6"  
#  13 therm_gay_t0                         68230     0.00216     0.0270 "FAL: 144, TRU: 4"  
#  14 therm_trans_t0                       68200     0.00260     0.0393 "FAL: 171, TRU: 7"  
#  15 therm_marijuana_t0                   68136     0.00354     0.0496 "FAL: 230, TRU: 12" 
#  16 therm_afams_t0                       68356     0.000322    0      "FAL: 22"           
#  17 ideology_t0                          67442     0.0137      0.200  "FAL: 749, TRU: 187"
#  18 religious_t0                         68378     0         NaN      ": "                
#  19 exposure_gay_t0                      68378     0         NaN      ": "                
#  20 exposure_trans_t0                    68378     0         NaN      ": "                
#  21 pid_t0                               68378     0         NaN      ": "                
#  22 scale_for_blocking_t0                68378     0         NaN      ": "                
#  23 survey_language_t0                   68378     0         NaN      ": "                
#  24 miami_trans_law_t1                   68222     0.00228     0.327  "FAL: 105, TRU: 51" 
#  25 miami_trans_law2_t1                  68231     0.00215     0.395  "FAL: 89, TRU: 58"  
#  26 therm_obama_t1                       68327     0.000746    0.0196 "FAL: 50, TRU: 1"   
#  27 therm_trans_t1                       68337     0.000600    0.0244 "FAL: 40, TRU: 1"   
#  28 therm_marijuana_t1                   68330     0.000702    0.0208 "FAL: 47, TRU: 1"   
#  29 gender_norm_looks_t1                 68100     0.00407     0.471  "FAL: 147, TRU: 131"
#  30 gender_norm_rights_t1                68050     0.00480     0.558  "TRU: 183, FAL: 145"
#  31 gender_norm_sexchange_t1             68021     0.00522     0.493  "FAL: 181, TRU: 176"
#  32 gender_norm_moral_t1                 68087     0.00426     0.320  "FAL: 198, TRU: 93" 
#  33 gender_norm_abnormal_t1              68073     0.00446     0.351  "FAL: 198, TRU: 107"
#  34 gender_norm_trans_moral_wrong_t1     68114     0.00386     0.277  "FAL: 191, TRU: 73" 
#  35 respondent_t1                        68378     0         NaN      ": "                
#  36 miami_trans_law_t2                   68226     0.00222     0.375  "FAL: 95, TRU: 57"  
#  37 miami_trans_law2_t2                  68220     0.00231     0.443  "FAL: 88, TRU: 70"  
#  38 therm_obama_t2                       68328     0.000731    0.04   "FAL: 48, TRU: 2"   
#  39 therm_jbush_t2                       68317     0.000892    0.0656 "FAL: 57, TRU: 4"   
#  40 therm_trans_t2                       68334     0.000643    0.0227 "FAL: 43, TRU: 1"   
#  41 therm_police_t2                      68364     0.000205    0      "FAL: 14"           
#  42 therm_firefighters_t2                68378     0         NaN      ": "                
#  43 gender_norm_looks_t2                 68131     0.00361     0.510  "TRU: 126, FAL: 121"
#  44 gender_norm_rights_t2                68110     0.00392     0.612  "TRU: 164, FAL: 104"
#  45 gender_norm_moral_t2                 68100     0.00407     0.374  "FAL: 174, TRU: 104"
#  46 gender_norm_dress_t2                 68100     0.00407     0.504  "TRU: 140, FAL: 138"
#  47 gender_norm_sexchange_t2             68055     0.00472     0.582  "TRU: 188, FAL: 135"
#  48 gender_norm_abnormal_t2              68110     0.00392     0.407  "FAL: 159, TRU: 109"
#  49 gender_norm_trans_moral_wrong_t2     68112     0.00389     0.342  "FAL: 175, TRU: 91" 
#  50 trans_teacher_t2                     68055     0.00472     0.502  "TRU: 162, FAL: 161"
#  51 trans_bathroom_t2                    68094     0.00415     0.356  "FAL: 183, TRU: 101"
#  52 respondent_t2                        68378     0         NaN      ": "                
#  53 miami_trans_law_withdef_t3           68210     0.00246     0.393  "FAL: 102, TRU: 66" 
#  54 miami_trans_law2_withdef_t3          68242     0.00199     0.426  "FAL: 78, TRU: 58"  
#  55 therm_obama_t3                       68335     0.000629    0.0465 "FAL: 41, TRU: 2"   
#  56 therm_jbush_t3                       68334     0.000643    0.114  "FAL: 39, TRU: 5"   
#  57 therm_trans_t3                       68340     0.000556    0      "FAL: 38"           
#  58 therm_police_t3                      68367     0.000161    0.182  "FAL: 9, TRU: 2"    
#  59 therm_firefighters_t3                68378     0         NaN      ": "                
#  60 gender_norm_looks_t3                 68107     0.00396     0.561  "TRU: 152, FAL: 119"
#  61 gender_norm_rights_t3                68078     0.00439     0.67   "TRU: 201, FAL: 99" 
#  62 gender_norm_moral_t3                 68110     0.00392     0.336  "FAL: 178, TRU: 90" 
#  63 gender_norm_dress_t3                 68094     0.00415     0.489  "FAL: 145, TRU: 139"
#  64 gender_norm_sexchange_t3             68038     0.00497     0.562  "TRU: 191, FAL: 149"
#  65 gender_norm_abnormal_t3              68104     0.00401     0.376  "FAL: 171, TRU: 103"
#  66 gender_norm_trans_moral_wrong_t3     68102     0.00404     0.330  "FAL: 185, TRU: 91" 
#  67 trans_teacher_t3                     68045     0.00487     0.498  "FAL: 167, TRU: 166"
#  68 trans_bathroom_t3                    68098     0.00409     0.332  "FAL: 187, TRU: 93" 
#  69 trans_ad_displayed_t3                68378     0         NaN      ": "                
#  70 trans_law_post_ad_t3                 68123     0.00373     0.231  "FAL: 196, TRU: 59" 
#  71 respondent_t3                        68378     0         NaN      ": "                
#  72 nfc_t3                               68378     0         NaN      ": "                
#  73 miami_trans_law_withdef_t4           68267     0.00162     0.288  "FAL: 79, TRU: 32"  
#  74 miami_trans_law2_withdef_t4          68268     0.00161     0.436  "FAL: 62, TRU: 48"  
#  75 therm_obama_t4                       68356     0.000322    0      "FAL: 22"           
#  76 therm_trans_t4                       68352     0.000380    0.0385 "FAL: 25, TRU: 1"   
#  77 therm_mousavi_t4                     68347     0.000453    0.0968 "FAL: 28, TRU: 3"   
#  78 gender_norm_looks_t4                 68198     0.00263     0.589  "TRU: 106, FAL: 74" 
#  79 gender_norm_rights_t4                68179     0.00291     0.608  "TRU: 121, FAL: 78" 
#  80 gender_norm_moral_t4                 68198     0.00263     0.389  "FAL: 110, TRU: 70" 
#  81 gender_norm_dress_t4                 68183     0.00285     0.544  "TRU: 106, FAL: 89" 
#  82 gender_norm_sexchange_t4             68137     0.00352     0.564  "TRU: 136, FAL: 105"
#  83 gender_norm_abnormal_t4              68194     0.00269     0.402  "FAL: 110, TRU: 74" 
#  84 gender_norm_trans_moral_wrong_t4     68196     0.00266     0.374  "FAL: 114, TRU: 68" 
#  85 trans_teacher_t4                     68144     0.00342     0.509  "TRU: 119, FAL: 115"
#  86 trans_bathroom_t4                    68176     0.00295     0.436  "FAL: 114, TRU: 88" 
#  87 respondent_t4                        68378     0         NaN      ": "                
#  88 marijuana_pread1                     68378     0         NaN      ": "                
#  89 marijuana_pread2                     68229     0.00218     0.678  "TRU: 101, FAL: 48" 
#  90 marijuana_postad                     68378     0         NaN      ": "                
#  91 exp_actual_convo                     68378     0         NaN      ": "                
#  92 contacted                            68378     0         NaN      ": "                
#  93 survey_language_es                   68378     0         NaN      ": "                
#  94 sdo_scale                            68378     0         NaN      ": "                
#  95 treat_ind                            68378     0         NaN      ": "                
#  96 canvass_recycling_rating             68378     0         NaN      ": "                
#  97 canvass_trans_ratingstart            68368     0.000146    0      "FAL: 10"           
#  98 canvass_trans_ratingsecond           68370     0.000117    0      "FAL: 8"            
#  99 canvass_trans_ratingend              68372     0.0000877   0      "FAL: 6"            
# 100 canvass_minutes                      68207     0.00250     0.298  "FAL: 120, TRU: 51" 
# 101 canvasser_experience                 68378     0         NaN      ": "                
# 102 canvasser_trans                      68378     0         NaN      ": "                
# 103 canvasser_id                         68378     0         NaN      ": "                
# 104 hh_id                                68378     0         NaN      ": "                
# 105 block_ind                            68378     0         NaN      ": "                
# 106 cluster_level_t0_scale_mean          68378     0         NaN      ": "                
# 107 vf_independent                       68378     0         NaN      ": "                
# 
# ── Variable type: numeric ──────────────────────────────────────────────────────────────────────────
#    skim_variable n_missing complete_rate       mean        sd    p0    p25    p50    p75  p100 hist 
#  1 id                    0         1     34190.     19739.        1 17095. 34190. 51284. 68378 ▇▇▇▇▇
#  2 vf_age            29367         0.571    49.2       18.5      16    33     49     63    106 ▇▇▇▃▁
#  3 vf_female             0         1         0.564      0.496     0     0      1      1      1 ▆▁▁▁▇
#  4 vf_black              0         1         0.298      0.458     0     0      0      1      1 ▇▁▁▁▃
#  5 vf_white              0         1         0.135      0.342     0     0      0      0      1 ▇▁▁▁▁
#  6 vf_hispanic           0         1         0.553      0.497     0     0      1      1      1 ▆▁▁▁▇
#  7 vf_vg_14              0         1         0.458      0.498     0     0      0      1      1 ▇▁▁▁▇
#  8 vf_vg_12              0         1         0.673      0.469     0     0      1      1      1 ▃▁▁▁▇
#  9 vf_vg_10              0         1         0.399      0.490     0     0      0      1      1 ▇▁▁▁▅
# 10 vf_democrat           0         1         0.452      0.498     0     0      0      1      1 ▇▁▁▁▆
# 11 vf_republican         0         1         0.286      0.452     0     0      0      1      1 ▇▁▁▁▃
# 12 respondent_t0         0         1         0.0267     0.161     0     0      0      0      1 ▇▁▁▁▁
```

## 해결방법

- 원인이 무엇일까?
    - `readr` 라이브러리의 함수들은 첫 1000행의 데이터를 통해 각 컬럼의 타입을 추정한다
    - 따라서 비어있는 값이 많은 컬럼들 중에서 첫 1000행 중에 데이터가 하나도 없다면 타입이 잘못 추론될 수 있다
- 어떻게 해결해야 할까?
    - 컬럼 수가 적고 타입을 정확히 알고 있다면 `col_types` 파라미터를 통해 타입을 직접 명시할 수 있다
    - 여기서는 컬럼 수가 너무 많기 때문에, 모든 컬럼을 문자열 타입으로 고정하여 불러오도록 한다
    - `read_tsv` 의 `col_types` 파라미터를 `cols(.default = "c")` 로 설정한다

```r
canvass_fixedtype <- read_tsv(canvass_data_url, col_types = cols(.default = "c"))
```

- 다시 데이터를 살펴보면 이번에는 모든 컬럼에 데이터가 잘 들어왔다는 것을 확인할 수 있다

```r
skimr::skim(canvass_fixedtype)
# ── Data Summary ────────────────────────
#                            Values           
# Name                       canvass_fixedtype
# Number of rows             68378            
# Number of columns          120              
# _______________________                     
# Column type frequency:                      
#   character                120              
# ________________________                    
# Group variables            None             
#
# ── Variable type: character ──────────────────────────────────────────────────────────────────────
#     skim_variable                    n_missing complete_rate   min   max empty n_unique whitespace
#   1 id                                       0       1           1     5     0    68378          0
#   2 vf_age                               29367       0.571       2     3     0       90          0
#   3 vf_party                             66553       0.0267      1    11     0        4          0
#   4 vf_racename                              0       1           5    16     0        7          0
#   5 vf_female                                0       1           3     3     0        2          0
#   6 vf_black                                 0       1           3     3     0        2          0
#   7 vf_white                                 0       1           3     3     0        2          0
#   8 vf_hispanic                              0       1           3     3     0        2          0
#   9 vf_vg_14                                 0       1           3     3     0        2          0
#  10 vf_vg_12                                 0       1           3     3     0        2          0
#  11 vf_vg_10                                 0       1           3     3     0        2          0
#  12 vf_democrat                              0       1           3     3     0        2          0
#  13 vf_republican                            0       1           3     3     0        2          0
#  14 miami_trans_law_t0                   66553       0.0267      1     2     0        7          0
#  15 miami_trans_law2_t0                  66553       0.0267      1     2     0        7          0
#  16 gender_norm_daugher_t0               66553       0.0267      1     2     0        5          0
#  17 gender_norm_looks_t0                 66553       0.0267      1     2     0        5          0
#  18 gender_norm_rights_t0                66553       0.0267      1     2     0        5          0
#  19 gender_norms_sexchange_t0            66553       0.0267      1     2     0        5          0
#  20 gender_norms_moral_t0                66553       0.0267      1     2     0        5          0
#  21 gender_norms_abnormal_t0             66553       0.0267      1     2     0        5          0
#  22 gender_norm_trans_moral_wrong_t0     67393       0.0144      1     2     0        5          0
#  23 ssm_t0                               66553       0.0267      1     2     0        7          0
#  24 therm_obama_t0                       66553       0.0267      1     3     0       95          0
#  25 therm_gay_t0                         66553       0.0267      1     3     0       99          0
#  26 therm_trans_t0                       66553       0.0267      1     3     0      101          0
#  27 therm_marijuana_t0                   66553       0.0267      1     3     0      101          0
#  28 therm_afams_t0                       66553       0.0267      1     3     0       84          0
#  29 ideology_t0                          66553       0.0267      1     2     0        7          0
#  30 religious_t0                         66553       0.0267      3     9     0        8          0
#  31 respondent_t0                            0       1           3     3     0        2          0
#  32 exposure_gay_t0                      66553       0.0267      3     3     0        2          0
#  33 exposure_trans_t0                    66553       0.0267      3     3     0        2          0
#  34 pid_t0                               66553       0.0267      3     4     0        7          0
#  35 scale_for_blocking_t0                66553       0.0267      7    13     0     1825          0
#  36 survey_language_t0                   67538       0.0123      2     2     0        2          0
#  37 miami_trans_law_t1                   67778       0.00877     1     2     0        7          0
#  38 miami_trans_law2_t1                  67778       0.00877     1     2     0        7          0
#  39 therm_obama_t1                       67778       0.00877     1     3     0       85          0
#  40 therm_trans_t1                       67778       0.00877     1     3     0       89          0
#  41 therm_marijuana_t1                   67778       0.00877     1     3     0       80          0
#  42 gender_norm_looks_t1                 67778       0.00877     1     2     0        5          0
#  43 gender_norm_rights_t1                67778       0.00877     1     2     0        5          0
#  44 gender_norm_sexchange_t1             67778       0.00877     1     2     0        5          0
#  45 gender_norm_moral_t1                 67778       0.00877     1     2     0        5          0
#  46 gender_norm_abnormal_t1              67778       0.00877     1     2     0        5          0
#  47 gender_norm_trans_moral_wrong_t1     67778       0.00877     1     2     0        5          0
#  48 respondent_t1                        66553       0.0267      3     3     0        2          0
#  49 miami_trans_law_t2                   67810       0.00831     1     2     0        7          0
#  50 miami_trans_law2_t2                  67810       0.00831     1     2     0        7          0
#  51 therm_obama_t2                       67810       0.00831     1     3     0       78          0
#  52 therm_jbush_t2                       67810       0.00831     1     3     0       91          0
#  53 therm_trans_t2                       67810       0.00831     1     3     0       86          0
#  54 therm_police_t2                      67810       0.00831     1     3     0       82          0
#  55 therm_firefighters_t2                67810       0.00831     1     3     0       51          0
#  56 gender_norm_looks_t2                 67810       0.00831     1     2     0        5          0
#  57 gender_norm_rights_t2                67810       0.00831     1     2     0        5          0
#  58 gender_norm_moral_t2                 67810       0.00831     1     2     0        5          0
#  59 gender_norm_dress_t2                 67810       0.00831     1     2     0        5          0
#  60 gender_norm_sexchange_t2             67810       0.00831     1     2     0        5          0
#  61 gender_norm_abnormal_t2              67810       0.00831     1     2     0        5          0
#  62 gender_norm_trans_moral_wrong_t2     67810       0.00831     1     2     0        5          0
#  63 trans_teacher_t2                     67810       0.00831     1     2     0        5          0
#  64 trans_bathroom_t2                    67810       0.00831     1     2     0        5          0
#  65 respondent_t2                        66553       0.0267      3     3     0        2          0
#  66 miami_trans_law_withdef_t3           67811       0.00829     1     2     0        7          0
#  67 miami_trans_law2_withdef_t3          67811       0.00829     1     2     0        7          0
#  68 therm_obama_t3                       67811       0.00829     1     3     0       74          0
#  69 therm_jbush_t3                       67811       0.00829     1     3     0       88          0
#  70 therm_trans_t3                       67811       0.00829     1     3     0       82          0
#  71 therm_police_t3                      67811       0.00829     1     3     0       83          0
#  72 therm_firefighters_t3                67811       0.00829     2     3     0       49          0
#  73 gender_norm_looks_t3                 67811       0.00829     1     2     0        5          0
#  74 gender_norm_rights_t3                67811       0.00829     1     2     0        5          0
#  75 gender_norm_moral_t3                 67811       0.00829     1     2     0        5          0
#  76 gender_norm_dress_t3                 67811       0.00829     1     2     0        5          0
#  77 gender_norm_sexchange_t3             67811       0.00829     1     2     0        5          0
#  78 gender_norm_abnormal_t3              67811       0.00829     1     2     0        5          0
#  79 gender_norm_trans_moral_wrong_t3     67811       0.00829     1     2     0        5          0
#  80 trans_teacher_t3                     67811       0.00829     1     2     0        5          0
#  81 trans_bathroom_t3                    67811       0.00829     1     2     0        5          0
#  82 trans_ad_displayed_t3                67914       0.00679    24    51     0        5          0
#  83 trans_law_post_ad_t3                 67811       0.00829     1     2     0        7          0
#  84 respondent_t3                        66553       0.0267      3     3     0        2          0
#  85 nfc_t3                               67811       0.00829     7    13     0      365          0
#  86 miami_trans_law_withdef_t4           67993       0.00563     1     2     0        7          0
#  87 miami_trans_law2_withdef_t4          67993       0.00563     1     2     0        7          0
#  88 therm_obama_t4                       67993       0.00563     1     3     0       63          0
#  89 therm_trans_t4                       67993       0.00563     1     3     0       82          0
#  90 therm_mousavi_t4                     67993       0.00563     1     3     0       49          0
#  91 gender_norm_looks_t4                 67993       0.00563     1     2     0        5          0
#  92 gender_norm_rights_t4                67993       0.00563     1     2     0        5          0
#  93 gender_norm_moral_t4                 67993       0.00563     1     2     0        5          0
#  94 gender_norm_dress_t4                 67993       0.00563     1     2     0        5          0
#  95 gender_norm_sexchange_t4             67993       0.00563     1     2     0        5          0
#  96 gender_norm_abnormal_t4              67993       0.00563     1     2     0        5          0
#  97 gender_norm_trans_moral_wrong_t4     67993       0.00563     1     2     0        5          0
#  98 trans_teacher_t4                     67993       0.00563     1     2     0        5          0
#  99 trans_bathroom_t4                    67993       0.00563     1     2     0        5          0
# 100 respondent_t4                        66553       0.0267      3     3     0        2          0
# 101 marijuana_pread1                     67811       0.00829     3     3     0        2          0
# 102 marijuana_pread2                     67811       0.00829     1     2     0        7          0
# 103 marijuana_postad                     67811       0.00829     3     3     0        2          0
# 104 exp_actual_convo                     67877       0.00733     9    14     0        2          0
# 105 contacted                            66553       0.0267      3     3     0        2          0
# 106 survey_language_es                   67393       0.0144      3     3     0        2          0
# 107 sdo_scale                            66553       0.0267      3    14     0      886          0
# 108 treat_ind                            66553       0.0267      3     3     0        2          0
# 109 canvass_recycling_rating             68159       0.00320     7     9     0        3          0
# 110 canvass_trans_ratingstart            68171       0.00303     1     2     0       10          0
# 111 canvass_trans_ratingsecond           68194       0.00269     1     2     0       10          0
# 112 canvass_trans_ratingend              68197       0.00265     1     2     0        8          0
# 113 canvass_minutes                      67891       0.00712     1     2     0       28          0
# 114 canvasser_experience                 67891       0.00712     2     3     0        2          0
# 115 canvasser_trans                      67891       0.00712     3     3     0        2          0
# 116 canvasser_id                         67891       0.00712     3     4     0       56          0
# 117 hh_id                                66553       0.0267      8    12     0     1295          0
# 118 block_ind                            66553       0.0267      7    10     0      648          0
# 119 cluster_level_t0_scale_mean          66553       0.0267      7    13     0     1295          0
# 120 vf_independent                       66553       0.0267      3     3     0        2          0
```

- 참고: 타입별 약어는 다음과 같다
    - c = character
    - i = integer
    - n = number
    - d = double
    - l = logical
    - f = factor
    - D = date
    - T = date time
    - t = time
    - ? = guess
    - _ or - = skip

# 참고자료

[readr Issue#48 :A easy way to read all columns as character](https://github.com/tidyverse/readr/issues/148#issuecomment-142428658)
