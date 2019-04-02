# R CMD BATCH에서 script에 argument 적용하기

- R을 Cmd 환경에서 argument와 함께 호출하려면 어떻게 해야 할까?

## R CMD BATCH

- R CMD BATCH 명령어를 통해 특정 R 스크립트를 cmd 환경에서 실행시킬 수 있다
- R CMD BATCH 명령어는 다음과 같은 형태로 구성되어 있다
    - R CMD BATCH [options] infile [outfile]
    - outfile이 명시되지 않으면 infile.Rout 확장자로 결과가 반환되는 것 같다
- 실행된 소스 코드와 소요 시간 등이 정리되어 outfile에 기록된다

```
R CMD BATCH [options] infile [outfile]

-- test.R : 실행시키려는 R 스크립트
-- test.out : 결과 파일
R CMD BATCH --no-save --no-restore '--args a=1 b=c(2,5,6)' test.R test.out
```

- 위와 같은 형태로 정리한 경우 `commandArgs(TRUE)` 함수를 통해 argument 들을 받아올 수 있다
    - 다만 객체로 불러들이는 것은 아니고 문자열로 바로 저장한
    - `[1] "a=1"`
    - `[2] "b=c(2,5,6)"`
    - 이런 식으로 저장된다
- 따라서 해당 텍스트를 바로 `eval` 을 통해 실행시켜서 실제 객체로 저장해버린다
- 다음과 같은 R 파일을 만들고 cmd 환경에서 실행시키면 argument를 받아올 수 있다

```r
##First read in the arguments listed at the command line
args = (commandArgs(TRUE))

##args is now a list of character vectors
## First check to see if arguments are passed.
## Then cycle through each element of the list and evaluate the expressions.
if(length(args)==0){
    print("No arguments supplied.")
    ##supply default values
    a = 1
    b = c(1,1,1)
}else{
    for(i in seq_along(args)){
         eval(parse(text=args[[i]]))
    }
}
print(a*2)
print(b*3)
```

더 좋은 방법이 있겠지만, 일단 추가적인 패키지를 설치하기 어려운 상황을 가정했다.
보다 나은 방법이 있는지는 나중에 리서치해보는 것으로.

# Reference

- R 스크립트를 인자와 함께 실행
    - 다양한 R Script 실행 방법이 정리되어 있다
    - https://statkclee.github.io/parallel-r/r-parallel-rscript-exec.html
- Including arguments in R CMD BATCH mode
    - argument를 읽어들이는 방법
    - https://www.r-bloggers.com/including-arguments-in-r-cmd-batch-mode/
- R CMD BATCH manual
    - https://stat.ethz.ch/R-manual/R-devel/library/utils/html/BATCH.html
