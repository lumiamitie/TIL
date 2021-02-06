# JS에서 CSV 다운로드 기능 구현하기

- 백엔드에서 제공하는 API를 통해 전달받은 데이터를 사용자가 다운로드 받을 수 있게 하려고 한다.

```javascript
function downloadCSV({ data, exportFilename = "result.csv" }) {
  // 
  var csvData = new Blob([data], { type: "text/csv;charset=utf-8;" });
  //IE11 & Edge
  if (navigator.msSaveBlob) {
    navigator.msSaveBlob(csvData, exportFilename);
  } else {
    //In FF link must be added to DOM to be clicked
    var link = document.createElement("a");
    link.href = window.URL.createObjectURL(csvData);
    link.setAttribute("download", exportFilename);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}
```

- 참고
    - IE 및 구버전 사파리 등 download attribute가 지원되지 않는 브라우저에서는 동작하지 않는다

# 참고자료
- [PapaParse Issue #175 : A way to generate and download CSV files client-side](https://github.com/mholt/PapaParse/issues/175#issuecomment-201308792)
- [LogRocket Blog : Programmatic file downloads in the browser](https://blog.logrocket.com/programmatic-file-downloads-in-the-browser-9a5186298d5c/)
- [Download API Files With React & Fetch](https://medium.com/yellowcode/download-api-files-with-react-fetch-393e4dae0d9e)
