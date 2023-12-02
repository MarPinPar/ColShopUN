import { query } from '/scripts/Fetch.js'
// first 
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


// seco
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


const buttonSearchByTerm = document.getElementById('buttonSearchByTerm');
buttonSearchByTerm.onclick = async () => {
const searchTerm = document.getElementById('searchTerm').value;

  try {
    const response = await fetch(`/get_prices_by_search?search_term=${searchTerm}`);
    
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const prices = await response.json();

    // Handle the prices data as needed, for example:
    AllData.innerHTML = "";
    for (const price of prices) {
      const newDiv = document.createElement("div");
      newDiv.className = 'col-md-3';
      newDiv.innerHTML = `${price.tie_nombre} - ${price.pro_nombre} - ${price.pre_valor} - ${price.pre_fechaHora}`;
      AllData.appendChild(newDiv)
    }
  } catch (error) {
    console.error('Error fetching prices:', error.message);
  }
};
