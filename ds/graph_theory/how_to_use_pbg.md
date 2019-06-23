# PyTorch-BigGraph 적용하기

## Training Process

### (1) Preparing the data

- tsv 파일을 PBG 학습을 위한 포맷으로 변경한다
- 작업이 완료되면 `<Data-name>_partitioned` 디렉토리에 결과물이 저장된다
    - `sample_data.tsv` 을 입력했다면 `sample_data_partitioned` 디렉토리가 생성되고 그 아래에 데이터를 저장한다

```
torchbiggraph_import_from_tsv \
  --lhs-col=0 --rel-col=1 --rhs-col=2 \
  config.py \
  sample_data.tsv
```

원본 데이터는 다음과 같은 포맷으로 구성되어 있다.

- source, relation, target 순으로 되어 있다
- 각각의 열은 컬럼명 없이 tab으로 구분한다

```
id-10002456	  id-svc  svc-134101867
id-100030123  id-svc  svc-273897372
id-100087456  id-svc  svc-206016120
id-100096123  id-svc  svc-174168266
id-10013123	  id-svc  svc-26046510
```

config 파일은 다음과 같이 설정하고, `config.py`로 저장한다.

```python
entity_base = "data"

def get_torchbiggraph_config():

    config = dict(
        # I/O data
        entity_path=entity_base,
        edge_paths=[],
        checkpoint_path='model',

        # Graph structure
        entities={
            'all': {'num_partitions': 1},
        },
        relations=[{
            'name': 'all_edges',
            'lhs': 'all',
            'rhs': 'all',
            'operator': 'complex_diagonal',
        }],
        dynamic_relations=True,

        # Scoring model
        dimension=10,
        global_emb=False,
        comparator='dot',

        # Training
        num_epochs=50,
        num_uniform_negs=1000,
        loss_fn='softmax',
        lr=0.1,

        # Evaluation during training
        eval_fraction=0,  # to reproduce results, we need to use all training data
    )

    return config
```

### (2) Training

- `torchbiggraph_train` 명령어를 통해 학습을 시작할 수 있다
- 100만 row 데이터에 대해서 `num_epochs=50` 으로 로컬에서 30분 정도 소요되었다

```
torchbiggraph_train \
  config.py \
  -p edge_paths=<Data-name>_partitioned
```

### (3) Evaluation

학습이 완료되면 임베딩 결과를 hold out 세트와 비교하여 평가할 수 있다.

```
torchbiggraph_eval \
  config.py \
  -p edge_paths=<Data-name>_partitioned \
  -p relations.0.all_negs=true

# WARNING: Adding uniform negatives makes no sense when already using all negatives
# ( 0 , 0 ): Processed 1043420 edges in 8.5e+02 s (0.0012M/sec); load time: 0.018 s
# Stats for edge path 1 / 1, bucket ( 0 , 0 ): pos_rank:  3937.3 , mrr:  0.0459274 , r1:  0.0214521 , r10:  0.0898665 , r50:  0.194117 , auc:  0.979326 , count:  1043420
# Stats for edge path 1 / 1: pos_rank:  3937.3 , mrr:  0.0459274 , r1:  0.0214521 , r10:  0.0898665 , r50:  0.194117 , auc:  0.979326 , count:  1043420
# Stats: pos_rank:  3937.3 , mrr:  0.0459274 , r1:  0.0214521 , r10:  0.0898665 , r50:  0.194117 , auc:  0.979326 , count:  1043420
```

### (4) Converting the output

전처리 과정에서 노드나 관계의 이름들이 문자열에서 ordinal로 변경된다.
원래의 이름을 가지는 임베딩 결과를 추출하기 위해서는 다음과 같은 명령어를 실행한다.

```
torchbiggraph_export_to_tsv \
  --dict data/dictionary.json \
  --checkpoint model \
  --out joined_embeddings.tsv
```
