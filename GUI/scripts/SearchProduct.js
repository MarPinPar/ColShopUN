import { query } from '/scripts/Fetch.js'

const buttonSearch = document.getElementById("buttonSearch")
const AllData = document.getElementById('AllData')
const buttonSearchByPrice = document.getElementById('buttonSearchByPrice')

buttonSearch.onclick = async () => {
  const allProducts = await query('get_all_products', {}, null, 'GET')
  AllData.innerHTML = ""
  for (const product of allProducts.productos) {
    const newDiv = document.createElement("div")
    newDiv.className = 'col-md-3 mb-3'
    newDiv.innerHTML = product.pro_nombre
    AllData.appendChild(newDiv)
  }
}

buttonSearchByPrice.onclick = async () => {
  const product_name = document.getElementById('productName').value;
  const LowestPrice = await query(
    `get_lowest_price?product_name=${product_name}`,
    {},
    null, 'GET'
  )
  const newDiv = document.createElement("div")
  newDiv.className = 'col-md-3'
  newDiv.innerHTML = LowestPrice.tie_nombre + LowestPrice.pre_valor
  AllData.innerHTML = ""
  AllData.appendChild(newDiv)
}
