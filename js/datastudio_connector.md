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
