# Node.js 어플리케이션을 도커 컨테이너에 넣기

도커 파일을 다음과 같이 구성한다.

```dockerfile
# node LTS 버전을 사용한다
FROM node:12.14

# 앱 디렉터리를 생성한다
WORKDIR /app

# 앱 의존성 설치
# - package.json과 package-lock.json을 모두 복사하여 설치하기 위해 와일드카드 문자를 사용한다
# - 전체 코드를 복사하는 대신 package 관련 파일만 복사하여 디펜던시를 설치하게 되면,
#   다른 파일들이 변경되는 경우에는 캐시 레이어를 통해 기존에 설치한 디펜던시를 그대로 사용할 수 있다
COPY package*.json ./
RUN npm install

# 저장소의 나머지 코드를 컨테이너 안에 복사한다
COPY . ./

# node app.js 명령을 실행한다
CMD [ "node", "app.js" ]
```

# 참고자료

- [Node.js 웹 앱의 도커라이징](https://nodejs.org/ko/docs/guides/nodejs-docker-webapp/)
- [Docker for Node.js in Production](https://medium.com/better-programming/docker-for-node-js-in-production-b9dc0e9e48e0)
- [nodejs/docker-node | Docker and Node.js Best Practices](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md)
