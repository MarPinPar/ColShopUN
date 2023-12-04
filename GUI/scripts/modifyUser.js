import { query } from '/scripts/Fetch.js'

buttonModifyUser.onclick = async (event) => {
  const newEmail = encodeURIComponent(document.getElementById("inputEmail").value);
  const newAlias = encodeURIComponent(document.getElementById("inputUsername").value);

  const createListResponse = await query(
    `modify_user?new_alias=${newAlias}&new_correo=${newEmail}`,
    null, 'GET'  
  )
}
