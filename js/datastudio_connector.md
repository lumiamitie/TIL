# Google Data Studio Community Connector 만들기

[Codelab](https://codelabs.developers.google.com/codelabs/community-connectors/) 의 내용을 정리해보자.

목표는 사내망의 데이터를 데이터스튜디오에 바로 연결하는 것!

## Community Connector Workflow

기본적인 커뮤니티 컨넥터의 경우 다음과 같은 네 가지 함수를 정의해야 한다.

- `getAuthType()`
- `getConfig()`
- `getSchema()`
- `getData()`

컨넥터 내부에서는 아래와 같은 흐름으로 진행된다.

![png](https://codelabs.developers.google.com/codelabs/community-connectors/img/962155b82be8de99.png)

## Apps Script 프로젝트 설정하기

[Google Apps Script](https://script.google.com/) 페이지에 방문하여 새로운 스크립트를 생성한다.

1. **"새 스크립트"** 를 선택한다
2. `code.gs` 파일에 비어있는 `myFunction` 함수가 생성된다
3. 화면 왼쪽 상단에서 프로젝트명을 설정한다
4. `myFunction` 함수를 제거하고 스크립트 작성을 시작한다

## getAuthType() 정의하기

데이터 스튜디오는 인증 방식을 알아야 할 때마다 컨넥터의 `getAuthType()` 함수를 호출한다.
이 함수는 컨넥터가 서드파티 서비스를 인증하기 위해 필요로 하는 방식을 반환한다.

npm 다운로드 컨넥터의 경우 인증을 필요로 하지 않는다. 따라서 이 경우에는 `{ type: 'None' }` 을 반환한다.

```javascript
function getAuthType() {
  var response = { type: 'NONE' };
  return response;
}
```

사용할 수 있는 모든 인증 방식은 [Auth Type 문서](https://developers.google.com/datastudio/connector/reference#authtype)에서 확인할 수 있다.

## getConfig() 정의하기

컨넥터에 연결하기 전에 수정하고자 하는 옵션들이 있을 수 있다.
`getConfig()` 함수의 반환값을 조정하면 사용자들이 보게 될 configuration option을 정의할 수 있다.
데이터 스튜디오는 `getConfig()` 함수를 호출하여 컨넥터의 세부적인 옵션을 확인한다.

configuration 화면에서 다음과 같은 form input을 통해 사용자의 입력을 받을 수 있다.

| Element         | Type            | Description                                                                                 |
|-----------------|-----------------|---------------------------------------------------------------------------------------------|
| TEXTINPUT       | Input element   | A single-line text box                                                                      |
| TEXTAREA        | Input element   | A multi-line textarea box                                                                   |
| SELECT_SINGLE   | Input element   | A dropdown for single-select options                                                        |
| SELECT_MULTIPLE | Input element   | A dropdown for multi-select options                                                         |
| CHECKBOX        | Input element   | A single checkbox that can be used to capture boolean values                                |
| INFO            | Display element | A static plain-text box that can be used to provide instructions or information to the user |

`INFO` element를 사용해서 유저에게 설명하고, `TEXTINPUT` element를 통해 패키지 이름을 입력하게 한다.
`getConfig()` 함수의 반환값에서, `configParams` 키의 하위 항목으로 form element 들을 확인할 수 있다.

여기서는 날짜를 파라미터로 입력받아야하기 때문에, `dateRangeRequired` 항목을 `true` 로 설정해야 한다.
만약 컨넥터에서 날짜를 입력할 필요가 없다면 이 부분은 생략해도 된다.

```javascript
// code.js
function getConfig(request) {
  var cc = DataStudioApp.createCommunityConnector();
  var config = cc.getConfig();

  config.newInfo()
    .setId('instructions')
    .setText('Enter npm package names to fetch their download count.');

  config.newTextInput()
    .setId('package')
    .setName('Enter a single package name')
    .setHelpText('e.g. googleapis or lightouse')
    .setPlaceholder('googleapis');

  config.setDateRangeRequired(true);

  return config.build();
}
```

## getSchema() 정의하기

데이터 스튜디오는 `getSchema()` 함수를 통해 스키마를 확인하고, 사용자가 볼 수 있는 필드를 제공한다.

기본적으로 스키마는 컨넥터가 제공할 수 있는 모든 필드의 목록을 말한다.
동일한 컨넥터에서도 설정에 따라 다른 스키마를 제공해야 할 수 있다.
스키마는 API를 통해 전달되는 필드, Apps Script에서 계산된 필드, 데이터 스튜디오에서 계산된 필드를 포함한다.

스키마의 각 필드에 대해서 메타 정보를 제공해야 한다.

- 필드의 이름
- 필드의 데이터 타입
- 설명

[getSchema 문서](https://developers.google.com/datastudio/connector/reference#getschema)나
[Field 문서](https://developers.google.com/datastudio/connector/reference#field)를 참고하여 자세한 내용을 확인할 수 있다.

데이터를 불러오는 방식에 따라 스키마가 고정될 수도 있고, `getSchema()`가 호출될 때 마다 동적으로 생성될 수도 있다.
세 개의 고정된 필드(`packageName`, `downloads`, `day`)를 불러오도록 설정해보자.

```javascript
function getFields(request) {
  var cc = DataStudioApp.createCommunityConnector();
  var fields = cc.getFields();
  var types = cc.FieldType;
  var aggregations = cc.AggregationType;

  fields.newDimension()
    .setId('packageName')
    .setType(types.TEXT);

  fields.newMetric()
    .setId('downloads')
    .setType(types.NUMBER)
    .setAggregation(aggregations.SUM);

  fields.newDimension()
    .setId('day')
    .setType(types.YEAR_MONTH_DAY);

  return fields;
}

function getSchema(request) {
  var fields = getFields(request).build();
  return { schema: fields };
}
```

## getData() 정의하기

데이터 스튜디오는 컨넥터를 통해 field에 정의된 데이터를 가져올 때마다 `getData()` 함수를 호출한다.
`getData()` 함수가 반환하는 값을 바탕으로 대시보드의 차트를 업데이트하게 된다.
`getData()` 함수는 다음과 같은 상황에 호출될 수 있다.

- 사용자가 대시보드에 차트를 추가할 때
- 사용자가 차트를 수정할 때
- 사용자가 대시보드를 볼 때
- 사용자가 컨트롤(기간, 필터, 데이터) 수정할 때
- 데이터스튜디오에서 데이터를 샘플링해야 할 때

### 1) Request 객체 이해하기

데이터 스튜디오는 `getData()`를 사용할 때 request 객체를 보낸다.

```javascript
{
  configParams: { // getConfig() 에서 설정된 값
    package: 'jquery'
  },
  // scriptParams: { // 컨넥터 실행을 위해 필요한 정보
  //   ...
  // },
  dateRange: { // getConfig()에서 필요로 할 경우 넘길 날짜 정보
    endDate: '2017-07-16',
    startDate: '2017-07-18'
  },
  fields: [ // 요청받은 필드의 이름
    {
      name: 'day',
    },
    {
      name: 'downloads',
    }
  ]
}
```

### 2) getData 함수의 구조

`getData()` 함수에서 결과값을 반환하기 위해서는 스키마와 데이터를 동시에 제공해야 한다.
코드를 다음과 같이 크게 세 가지 단계로 나누어 볼 수 있다.

- 요청받은 필드에 대한 스키마를 생성한다
- API를 통해 데이터를 받아온다
- 파싱한 데이터를 요청받은 필드에 맞게 가공한다

#### 스키마 생성하기

```javascript
// Create schema for requested fields
var requestedFieldIds = request.fields.map(function(field) {
  return field.name;
});
var requestedFields = getFields().forIds(requestedFieldIds);
```

#### API를 통해 데이터 받아오기

예제로 사용할 [npm API](https://github.com/npm/registry/blob/master/docs/download-counts.md)는 다음과 같이 구성되어 있다.

```
https://api.npmjs.org/downloads/point/{start_date}:{end_date}/{package}

Example : https://api.npmjs.org/downloads/range/2019-06-01:2019-06-02/vue
Response :
{
  "start":"2019-06-01",
  "end":"2019-06-02",
  "package":"vue",
  "downloads":[
    {"downloads":41885,"day":"2019-06-01"},
    {"downloads":40816,"day":"2019-06-02"}
  ]
}
```

API를 통해 데이터를 요청하고 결과를 파싱한다.

```javascript
// Fetch and parse data from API
var url = [
  'https://api.npmjs.org/downloads/range/',
  request.dateRange.startDate,
  ':',
  request.dateRange.endDate,
  '/',
  request.configParams.package
];
var response = UrlFetchApp.fetch(url.join(''));
var parsedResponse = JSON.parse(response).downloads;
```

#### 필드에 맞게 데이터 가공하기

결과를 반환할 때, 스키마는 `schema` 프로퍼티, 데이터는 `rows` 프로퍼티를 통해 전달한다.
데이터는 row들의 리스트 형태로 전달하는데, `values` 배열에서 값의 순서는 스키마의 필드 순서와 동일해야 한다.
예제에서는 다음과 같은 형태로 구성된다.

```
{
  schema: requestedFields.build(),
  rows: [
    {
      values: [ 41885, '20190601']
    },
    {
      values: [ 40816, '20190602']
    }
  ]
}
```

다음 함수를 사용해서 요청받은 필드에 해당하는 데이터를 변환할 수 있다.

```javascript
function responseToRows(requestedFields, response, packageName) {
  // Transform parsed data and filter for requested fields
  return response.map(function(dailyDownload) {
    var row = [];
    requestedFields.asArray().forEach(function (field) {
      switch (field.getId()) {
        case 'day':
          return row.push(dailyDownload.day.replace(/-/g, ''));
        case 'downloads':
          return row.push(dailyDownload.downloads);
        case 'packageName':
          return row.push(packageName);
        default:
          return row.push('');
      }
    });
    return { values: row };
  });
}
```

### 3) 완성된 getData 함수

다음 코드를 스크립트에 추가한다.

```javascript
function responseToRows(requestedFields, response, packageName) {
  // Transform parsed data and filter for requested fields
  return response.map(function(dailyDownload) {
    var row = [];
    requestedFields.asArray().forEach(function (field) {
      switch (field.getId()) {
        case 'day':
          return row.push(dailyDownload.day.replace(/-/g, ''));
        case 'downloads':
          return row.push(dailyDownload.downloads);
        case 'packageName':
          return row.push(packageName);
        default:
          return row.push('');
      }
    });
    return { values: row };
  });
}

function getData(request) {
  var requestedFieldIds = request.fields.map(function(field) {
    return field.name;
  });
  var requestedFields = getFields().forIds(requestedFieldIds);

  // Fetch and parse data from API
  var url = [
    'https://api.npmjs.org/downloads/range/',
    request.dateRange.startDate,
    ':',
    request.dateRange.endDate,
    '/',
    request.configParams.package
  ];
  var response = UrlFetchApp.fetch(url.join(''));
  var parsedResponse = JSON.parse(response).downloads;
  var rows = responseToRows(requestedFields, parsedResponse, request.configParams.package);

  return {
    schema: requestedFields.build(),
    rows: rows
  };
}
```

## Manifest 업데이트하기

Apps Script에서 `보기 > 매니페스트 파일 표시` 를 선택하면 `appsscript.json` 파일이 생성된다.
다음과 같이 수정하고 저장한다.

```
{
  "dataStudio": {
    "name": "npm Downloads - From Codelab",
    "logoUrl": "https://raw.githubusercontent.com/npm/logos/master/%22npm%22%20lockup/npm-logo-simplifed-with-white-space.png",
    "company": "Codelab user",
    "companyUrl": "https://developers.google.com/datastudio/",
    "addonUrl": "https://github.com/google/datastudio/tree/master/community-connectors/npm-downloads",
    "supportUrl": "https://github.com/google/datastudio/issues",
    "description": "Get npm package download counts.",
    "sources": ["npm"]
  }
}
```

## 컨넥터를 데이터스튜디오에서 테스트해보기

### 배포하기

1. `게시 > 매니페스트에서 배포` 를 선택한다
2. `Get ID` 왼쪽에 있는 데이터스튜디오 로고를 클릭하면 컨넥터 링크가 생성된다
3. 컨넥터 링크를 클릭하면 새로운 데이터스튜디오 화면이 뜬다

### 컨넥터 인증하기

다음과 같은 문구가 뜬다. "승인" 버튼을 누른다.

> 데이터 스튜디오에서 이 커뮤니티 커넥터를 사용하려면 승인이 필요합니다.

# 참고

위에서 정리한 코드들이 생각보다 많이 outdated 된 것 같다. 아래 문서 참고해서 다시 정리해보자..

https://developers.google.com/datastudio/connector/build
