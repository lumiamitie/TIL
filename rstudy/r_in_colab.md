# Installing R kernel in Colaboratory Notebook

구글 Colaboratory Notebook에 R 커널을 설치하는 방법을 발견하여 정리한다.

- [원본 문서 링크 : Stan Community](https://discourse.mc-stan.org/t/r-jupyter-notebook-rstan-on-google-colab/6101)
- [Colab Notebook : Install R](https://colab.research.google.com/drive/1xj_aYLBBPX2oSQ1I4xp5_YZiVhhpC1Ke)
- [Colab Notebook : Install R + brms](https://colab.research.google.com/drive/1_MmJuotDr9izNwivjgfD1J_bd4OvTFLq)

## Setup code

1. 아래 **Setup Code** 를 한 번 동작시킨다
    - 설치하는데 2~3분 정도 소요된다
2. **런타임 > 세션관리 > (현재 세션) 종료** 를 선택한다
    - **Runtime > Manage Sessions > TERMINATE**
3. **런타임 다시 시작 (Restart Runtime)** 을 클릭하고, 세션에 **RECONNECT** 한다
    - 설치가 완료되면 python2 커널이 R 커널로 바뀐다
4. 이제 R Code를 실행시킬 수 있다 (Setup Code는 실행시키지 않는다)
5. Reset All Runtimes (모든 런타임 재설정) 를 누르면 초기화되어 파이썬 커널로 되돌아간다.
