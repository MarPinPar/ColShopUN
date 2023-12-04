
export const query = (endpoint, body, method, contentType = 'application/json') => {

  let bodyString = null;

  if (body) {
    if (contentType === 'application/json') {
      bodyString = JSON.stringify(body)
    } else if (contentType === 'application/x-www-form-urlencoded') {
      let formBody = [];
      for (let property in body) {
        let encodedKey = encodeURIComponent(property);
        let encodedValue = encodeURIComponent(body[property]);
        formBody.push(encodedKey + "=" + encodedValue);
      }
      bodyString = formBody.join("&");
    }
  }

  const headers = {
    'Content-Type': contentType
  };

  const token = localStorage.getItem("token");
  
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  return new Promise((resolve, reject) => {
    fetch('http://127.0.0.1:8000/' + endpoint, {
      method: method,
      cache: 'no-cache',
      credentials: 'same-origin',
      headers: headers,
      body: bodyString,
      redirect: 'follow',
      referrerPolicy: 'no-referrer',
    }).then(
      (data) => {
        data.json().then(
          decode => resolve(decode)
        ).catch(e => reject(e))
      }
    ).catch(
      e => reject(e)
    )
  }

  )
}

