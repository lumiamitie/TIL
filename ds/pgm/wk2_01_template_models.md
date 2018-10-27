
# Template Models

## Overview of template models

* 그래피컬 모형을 여러 케이스에 적용할 수 있도록 확장해보자
    * 특정한 케이스에 맞는 모형이 아니라 다양한 문제를 다룰 수 있도록 일반화시키고자 한다
* Genetic Inheritance 예제
    * input : pedigree => 특정한 trait에 대해 추론하고자 한다
    * 가계도를 바탕으로 베이지안 네트워크를 구성할 경우, 대상자를 추가하거나 다른 가계도에 대해 비슷한 것들을 적용할 수 있다
        * 이런 경우에 동일한 아이디어를 재사용할 수 있으면 좋지 않을까?
        * "Sharing between models"
    * 모형 내에서도 공유할 수 있는 것들이 있다 (Sharing within model)
        * Genotype -> Bloodtype 으로 영향을 미치는 프로세스는 모든 사람에게 동일하게 발생한다
        * 어떤 사람의 genotype은 부모의 genotype에서 영향을 받는다
    * 거대한 모형을 비교적 적은 파라미터를 통해 표현할 수 있을까?
* NLP Sequence Models
    * Sequence model을 이용한 named entity 인식 문제
    * 각 단어마다 어떤 종류의 단어인지에 대한 latent variable이 존재한다
    * parameter를 재사용하는 것이 도움이 될 수 있다
* Image Segmentation
    * Sharing across superpixels or pixels
        * 각 superpixel이 무엇을 의미하는가
        * Edge potential
        * Pairs of adjacent superpixels
    * Sharing between models
* The University Example
    * 어떤 학생이 수업을 듣고 학점을 받는다. 학점은 수업 난이도의 영향을 받는다
    * 특정 학생이 아니라 대학 전체를 대상으로 모형을 구축한다면??
        * 다양한 난이도, 수업, 학생 등 변수가 존재한다
        * 각 학점 변수는 연관된 수업, 학생 등의 변수에서 영향을 받는다
        * Dependency structure와 CPD는 각 모형이 동일하다
* Robot Localization
    * Time Series 문제
        * 로봇은 시간이 지남에 따라 이리저리 움직인다
        * 로봇이 움직이는 방식 자체는 고정되어 있음 (We expected the dynamics of the robot are fixed)

* Template Variables
    * Template variable X(U_1 , ... , U_k) is instantiated (duplicated) multiple times
    * 모형 내에서 사용되기도 하고, 모형간에 사용되기도 한다
* Template Models
    * 변수 (Ground variables) 들이 템플릿으로부터 의존 관계를 어떻게 상속받는지 표현한다
    * Dynamic Bayesian Networks
        * temporal process
    * Object-relational models
        * Directed
            * Plate models
        * Undirected
