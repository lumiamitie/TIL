# SQL에서 그룹별로 한 개씩 랜덤하게 추출하기

다음과 같은 테이블이 있다. 여기서 그룹별로 랜덤하게 한 개씩 항목을 추출하려면 어떻게 해야 할까?

```sql
CREATE TABLE images (
        id int auto_increment primary key, 
        case_id int(11),
        image_path varchar(50)
);

INSERT INTO images
(case_id, image_path)
VALUES
(1, '1_image1.jpg'),
(1, '1_image2.jpg'),
(1, '1_image3.jpg'),
(2, '2_image1.jpg'),
(2, '2_image2.jpg'),
(2, '2_image3.jpg'),
(2, '2_image4.jpg'),
(3, '3_image1.jpg'),
(3, '3_image2.jpg');

-- | case_id | image_path   |
-- |---------|--------------|
-- | 1	     | 1_image1.jpg |
-- | 1	     | 1_image2.jpg |
-- | 1	     | 1_image3.jpg |
-- | 2       | 2_image1.jpg |
-- | 2       | 2_image2.jpg |
-- | 2       | 2_image3.jpg |
-- | 2       | 2_image4.jpg |
-- | 3       | 3_image1.jpg |
-- | 3       | 3_image2.jpg |
```

다음과 같이 `GROUP_CONCAT` 과 `SUBSTRING_INDEX` 를 조합하여 추출할 수 있다.

```sql
SELECT case_id, 
        SUBSTRING_INDEX(GROUP_CONCAT(image_path ORDER BY rand()), ',', 1) AS image_path
FROM images
GROUP BY case_id
;

-- | case_id | image_path   |
-- |---------|--------------|
-- | 1	     | 1_image3.jpg |
-- | 2       | 2_image1.jpg |
-- | 3       | 3_image2.jpg |
```

[참고: How to select a random row with a group by clause?](https://stackoverflow.com/a/28515156)
