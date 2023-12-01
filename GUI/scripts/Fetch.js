export const query = (endpoint, params, body, method) => {
    return new Promise((resolve, reject) => {
        fetch('http://127.0.0.1:8000/'+ endpoint, {
            method: method, // *GET, POST, PUT, DELETE, etc. // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: { 
                'Content-Type': 'application/json'
            },
            params : params,
            body : body,
            redirect: 'follow', // manual, *follow, error
            referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, 
            } ).then(
                (data) => {
                    data.json().then(
                        decode => resolve(decode)
                    ).catch(e => reject(e))
                }
            ).catch(
                e => reject(e)
                
            )
        }

    )}

