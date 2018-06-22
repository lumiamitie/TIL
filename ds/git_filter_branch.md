# 문제상황

* 실수로 100메가가 넘는 feather 파일을 커밋해버렸다
* 파일 제거후 다시 커밋을 하고 push했더니 다음과 같은 오류가 발생하면서 push가 실패한다
    * remote: error: GH001: Large files detected.

```
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
remote: error: File dashboard_project/target_ids.feather is 182.72 MB; this exceeds GitHub Enterprise's file size limit of 100.00 MB
To https://github.daumkakao.com/miika-mh/py_analysis_code.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'https://github.daumkakao.com/miika-mh/py_analysis_code.git'
```

# 해결방법

* <http://thomas-cokelaer.info/blog/2018/02/git-how-to-remove-a-big-file-wrongly-committed/>
* 다음 명령어를 통해 tree에서 해당 대용량 파일을 제거하고 다시 push를 수행한다

```
git filter-branch --tree-filter 'rm -rf path/to/your/file' HEAD
git push

------

$ git filter-branch --tree-filter 'rm -rf dashboard_project/target_ids.feather' HEAD
Rewrite 3108a3c439628bf8fb4debd972f436ca511fc45b (4/4)
Ref 'refs/heads/master' was rewritten

$ git push
```