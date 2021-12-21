# conda 환경을 처음 설정할 때 발생하는 CommandNotFoundError 해결하기

## 문제상황

- conda create 명령으로 새로운 conda 환경을 생성했다.
- 생성한 환경을 반영하기 위해 conda activate 명령을 사용했는데, 에러가 발생했다.
    - `CommandNotFoundError`
- 어떻게 해결해야 할까?

```bash
conda create --name miika_env
# To activate this environment, use
#
#     $ conda activate miika_env
#
# To deactivate an active environment, use
#
#     $ conda deactivate

deploy@95edd3d0a8dc:~$ conda activate miika_env
# CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
# To initialize your shell, run

#     $ conda init <SHELL_NAME>

# Currently supported shells are:
#   - bash
#   - fish
#   - tcsh
#   - xonsh
#   - zsh
#   - powershell

# See 'conda init --help' for more information and options.

# IMPORTANT: You may need to close and restart your shell after running 'conda init'.
```

## 해결방법

- 사용하는 쉘에서 conda를 적용할 수 있도록 설정을 반영해야 한다
- 직접 `.bashrc` 파일을 수정해도 되지만, conda에서 제공하는 명령을 사용하면 된다.

```bash
# conda init <SHELL_NAME>
conda init bash
```

- 적용 후에는 잘 반영되는 것을 확인할 수 있다.

```bash
deploy@95edd3d0a8dc:~$ conda init bash
# no change     /home/deploy/anaconda3/condabin/conda
# no change     /home/deploy/anaconda3/bin/conda
# no change     /home/deploy/anaconda3/bin/conda-env
# no change     /home/deploy/anaconda3/bin/activate
# no change     /home/deploy/anaconda3/bin/deactivate
# no change     /home/deploy/anaconda3/etc/profile.d/conda.sh
# no change     /home/deploy/anaconda3/etc/fish/conf.d/conda.fish
# no change     /home/deploy/anaconda3/shell/condabin/Conda.psm1
# no change     /home/deploy/anaconda3/shell/condabin/conda-hook.ps1
# no change     /home/deploy/anaconda3/lib/python3.7/site-packages/xontrib/conda.xsh
# no change     /home/deploy/anaconda3/etc/profile.d/conda.csh
# modified      /home/deploy/.bashrc

# ==> For changes to take effect, close and re-open your current shell. <==

# 적용한 다음에는 shell을 재시작하면 아래와 같이 수정사항이 반영된다. 
# 현재 환경을 보여주는 영역이 shell에 추가되었다. ("(base)" 부분)
deploy@95edd3d0a8dc:~$ exit
# exit
$ bash
(base) deploy@95edd3d0a8dc:~$

# 이제 conda activate가 잘 동작한다
(base) deploy@95edd3d0a8dc:~$ conda activate miika_env
(miika_env) deploy@95edd3d0a8dc:~$
```
