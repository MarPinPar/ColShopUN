import { query } from '/scripts/Fetch.js'
import { createProductsTable } from '/scripts/views/productsTable.js'
import { parseDate, parsePrice } from '/scripts/utils.js';

const buttonSearch = document.getElementById("buttonSearch")
const allData = document.getElementById('AllData')

buttonSearch.onclick = async () => {
  allData.innerHTML = ""

  const productName = encodeURIComponent(document.getElementById('productName').value);

  const lowestPriceResponse = await query(
    `get_lowest_price?product_name=${productName}`,
    null,
    'GET'
  )

  // Rendering lowest price title
  const lowestPriceParentContainer = document.createElement("div");
  lowestPriceParentContainer.className = "col-12"

  const lowestPriceContainer = document.createElement("div");
  lowestPriceContainer.className = "row text-center lowest-price-container"

  const lowestPriceTitle = document.createElement("div");
  lowestPriceTitle.className = "col-12 colshop-subtitle"
  lowestPriceTitle.textContent = "Precio mas bajo";
  lowestPriceContainer.appendChild(lowestPriceTitle);

  const lowestPriceProvider = document.createElement("div")
  lowestPriceProvider.className = 'col-12 col-sm-6 colshop-p'
  lowestPriceProvider.innerHTML = "<b>" + lowestPriceResponse.tie_nombre + "</b>"
  lowestPriceContainer.appendChild(lowestPriceProvider);

  const lowestPrice = document.createElement("div")
  lowestPrice.className = 'col-12 col-sm-6 colshop-p'
  lowestPrice.innerHTML = parsePrice(lowestPriceResponse.pre_valor)
  lowestPriceContainer.appendChild(lowestPrice);

  // const lowestPriceButton = document.createElement("div")
  // lowestPriceButton.className = 'col-12 col-sm-4 colshop-press-btn'
  // lowestPriceButton.style.margin = 'auto'
  // lowestPriceButton.innerHTML = "Ir al producto"
  // lowestPriceContainer.appendChild(lowestPriceButton);

  lowestPriceParentContainer.appendChild(lowestPriceContainer);

  allData.appendChild(lowestPriceParentContainer)

  const allProducts = await query(
    `search_product?product_to_search=${productName}`,
    null, 'GET'
  )

  // const allProducts = {
  //   "result": [
  //     {
  //       "titulo": "Samsung Galaxy A34 5G 128 GB awesome graphite 6 GB RAM",
  //       "precio": 935402,
  //       "link": "https://www.mercadolibre.com.co/samsung-galaxy-a34-5g-128-gb-awesome-graphite-6-gb-ram/p/MCO22385548?pdp_filters=category:MCO1055#searchVariation=MCO22385548&position=1&search_layout=stack&type=product&tracking_id=2b37836b-645f-413f-b01c-09b1641fa991",
  //       "marca": "Samsung",
  //       "imagen": "https://http2.mlstatic.com/D_NQ_NP_680639-MLA54691106460_032023-V.webp",
  //       "empresa": "Mercado Libre",
  //       "fecha": "2023-12-01 12:18:27.827132",
  //       "id": "MCO1365228731",
  //       "idTienda": 2
  //     },
  //     {
  //       "titulo": "Samsung Galaxy A34 5G 5G Dual SIM 256 GB awesome silver 8 GB RAM",
  //       "precio": 1189900,
  //       "link": "https://www.mercadolibre.com.co/samsung-galaxy-a34-5g-5g-dual-sim-256-gb-awesome-silver-8-gb-ram/p/MCO23556929?pdp_filters=category:MCO1055#searchVariation=MCO23556929&position=2&search_layout=stack&type=product&tracking_id=2b37836b-645f-413f-b01c-09b1641fa991",
  //       "marca": "Samsung",
  //       "imagen": "https://http2.mlstatic.com/D_NQ_NP_680639-MLA54691106460_032023-V.webp",
  //       "empresa": "Mercado Libre",
  //       "fecha": "2023-12-01 12:18:27.827132",
  //       "id": "MCO1319575303",
  //       "idTienda": 2
  //     },
  //     {
  //       "titulo": "Samsung Galaxy A34 5g - 128gb - 6gb Ram",
  //       "precio": 1899900,
  //       "link": "https://articulo.mercadolibre.com.co/MCO-1349806979-samsung-galaxy-a34-5g-128gb-6gb-ram-_JM#position=5&search_layout=stack&type=item&tracking_id=2b37836b-645f-413f-b01c-09b1641fa991",
  //       "marca": "Samsung",
  //       "imagen": "https://http2.mlstatic.com/D_NQ_NP_680639-MLA54691106460_032023-V.webp",
  //       "empresa": "Mercado Libre",
  //       "fecha": "2023-12-01 12:18:27.827132",
  //       "id": "MCO1349806979",
  //       "idTienda": 2
  //     },
  //     {
  //       "titulo": "Celular Samsung Galaxy A34 5G 128GB Verde",
  //       "precio": 1498990,
  //       "link": "https://www.ktronix.com/celular-samsung-galaxy-a34-5g-128gb-verde/p/8806094835359",
  //       "marca": "Samsung",
  //       "imagen": "https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg",
  //       "empresa": "Ktronix",
  //       "fecha": "2023-12-01 12:18:58.940885",
  //       "id": "8806094835359",
  //       "idTienda": 1
  //     },
  //     {
  //       "titulo": "Celular Samsung Galaxy A34 5G 128GB Negro",
  //       "precio": 1498990,
  //       "link": "https://www.ktronix.com/celular-samsung-galaxy-a34-5g-128gb-negro/p/8806094835328",
  //       "marca": "Samsung",
  //       "imagen": "https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg",
  //       "empresa": "Ktronix",
  //       "fecha": "2023-12-01 12:18:58.940885",
  //       "id": "8806094835328",
  //       "idTienda": 1
  //     },
  //     {
  //       "titulo": "Celular Samsung Galaxy A34 5G 128GB Plata",
  //       "precio": 1498990,
  //       "link": "https://www.ktronix.com/celular-samsung-galaxy-a34-5g-128gb-plata/p/8806094835304",
  //       "marca": "Samsung",
  //       "imagen": "https://www.ktronix.com/_ui/responsive/theme-ktronix/images/missing_product_EN_300x300.jpg",
  //       "empresa": "Ktronix",
  //       "fecha": "2023-12-01 12:18:58.940885",
  //       "id": "8806094835304",
  //       "idTienda": 1
  //     }
  //   ]
  // }

  const table = createProductsTable(allProducts.result);

  allData.appendChild(table);

  // After rendering data, save the search
  const words = encodeURIComponent(productName);
  const searchRegistry = await query(
    `create_busqueda?palabras=${words}`,
    null,
    'POST'
  );

  console.log("Reg: ", searchRegistry);
}

