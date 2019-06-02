# fetch API 사용하는 방법

[JavaScript Fetch API Examples](https://gist.github.com/justsml/529d0b1ddc5249095ff4b890aad5e801)

```javascript
fetch('https://api.github.com/orgs/nodejs')
  .then(res => res.json())
  .then(data => {
    console.log(data) // Prints result from `res.json()` in getRequest
  })
  .catch(error => console.error(error))
```
