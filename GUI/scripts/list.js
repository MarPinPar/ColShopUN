import { query } from '/scripts/Fetch.js'
import { creatMyListTable } from '/scripts/views/ListsTable.js'

const createList = document.getElementById("createList")
const deleteList = document.getElementById("deleteProductsList")

createList.onclick = async (event) => {
  const listName = document.getElementById("listName").value;
  const listType = document.getElementById("listType").checked ? 1 : 0;

  await query(
    `create_list?list_name=${listName}&privada=${listType}`,
    null, 'GET'
  )

  window.onload();
}

// Obtain my products
const mainContainer = document.getElementById('misListasContainer');

window.onload = async (event) => {
  const params = new Proxy(new URLSearchParams(window.location.search), {
    get: (searchParams, prop) => searchParams.get(prop),
  });

  mainContainer.innerHTML = '';

  // Obtain my lists
  const misListas = await query(
    `get_mis_listas`,
    null, 'GET'
  );
  console.log(misListas)

  // Create table
  const myListTable = creatMyListTable(misListas);
  mainContainer.appendChild(myListTable);
};