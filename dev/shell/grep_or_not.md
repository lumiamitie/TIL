# grep 명령어 사용할 때 특정 패턴을 만족하는 항목만 출력하기

grep 명령어를 사용하다 원하는 필터링 조건에 맞는 결과만 출력하는 방법이 궁금해졌다. 
AND 조건은 grep을 파이프로 연결하면 해결할 수 있는데, OR나 NOT은 어떻게 처리할 수 있을까?

다음과 같이 `temp.txt` 를 생성한다.

```bash
100  Miika    Manager    Sales       5,000
101  Minho    Developer  Technology  5,500
102  Lee      Sysadmin   Technology  7,000
200  mino     Manager    Marketing   8,400
300  Someone  Manager    Brand       6,000
```

## OR

- `-e` 또는 `--regexp` 옵션을 사용할 경우
    - `\|` 연산자를 사용한다.
    - `-e` 옵션을 여러번 사용한다.
- `-E` 옵션을 사용할 경우 `|` 연산자를 사용하면 된다.
- 다음 명령어는 모두 같은 결과를 반환한다.

```bash
# -e 옵션을 여러번 사용하면 된다
grep -e Manager -e Sysadmin temp.txt

# -e, --regexp 옵션과 정규표현식을 사용한다
# 여기서는 \| 를 사용한다
grep -e "Manager\|Sysadmin" temp.txt
grep --regexp "Manager\|Sysadmin" temp.txt

# -E : Extended regular expression 을 사용한다
# 여기서는 그냥 | 를 사용한다
grep -E "Manager|Sysadmin" temp.txt

# 100  Miika    Manager    Sales       5,000
# 102  Lee      Sysadmin   Technology  7,000
# 200  mino     Manager    Marketing   8,400
# 300  Someone  Manager    Brand       6,000
```

## NOT

- `-v` 옵션을 추가하면 입력한 패턴에 해당하지 않는 항목을 반환하게 된다

```bash
grep -v -E "Manager|Sysadmin" temp.txt

# 101  Minho    Developer  Technology  5,500
```

# 참고자료

- [grep 명령어에서 AND, OR, NOT 조건 사용하기](https://twpower.github.io/173-grep-and-or-not)
- [7 Linux Grep OR, Grep AND, Grep NOT Operator Examples](https://www.thegeekstuff.com/2011/10/grep-or-and-not-operators/)
