# Freqpoly graph

```r
cross_category_demo %>% 
  group_by(group_name, age_band) %>% 
    summarise(user_cnt = sum(user_cnt)) %>% 
  ungroup %>% 
  group_by(group_name) %>% 
    mutate(ratio = user_cnt / sum(user_cnt)) %>% 
  ungroup %>% 
  mutate(group_name = factor(group_name, levels = c('서비스1', '교차사용자', '서비스2'))) %>% 
  ggplot(aes(x = factor(age_band), y = ratio, color = group_name, group = group_name)) +
    geom_freqpoly(stat = 'identity', alpha = 0.5, size = 2) + 
    geom_point(aes(color = group_name)) +
    scale_color_brewer('', palette = 'Set2') +
    scale_y_continuous(labels = scales::percent) +
    xlab('연령대') + ylab('비율') +
    theme_minimal(base_family = 'Kakao', base_size = 14) + 
    theme(panel.grid.minor.y = element_blank(), legend.position = 'top', legend.justification = 'right')
```
