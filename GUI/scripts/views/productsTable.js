import { parseDate, parsePrice } from '/scripts/utils.js';

export const createProductsTable = (
  products
) => {
  const table = document.createElement("div");
  table.className = "row products-table"

  for (const product of products) {

    const linkProduct = document.createElement("a");
    linkProduct.className = "col-12 col-md-4 col-sm-6 text-center products-item"
    linkProduct.href = `/pages/HistoricalProduct.html?product=${product.id}&store=${product.idTienda}`;

    // Generate product card
    const productCard = document.createElement("div");
    productCard.className = "card colshop-card";

    // Generate product card image
    const productImg = document.createElement("img");
    productImg.className = "card-img-top products-image";
    productImg.src = product.imagen;
    productCard.appendChild(productImg);

    // Generate product card body
    const productCardBody = document.createElement("div");
    productCardBody.className = "card-body";

    const productName = document.createElement("div");
    productName.className = "card-title";
    productName.innerHTML = product.titulo;
    productCardBody.appendChild(productName);

    const productPrice = document.createElement("div");
    productPrice.className = "card-text";
    productPrice.innerHTML += "<b>Precio: </b>" + parsePrice(product.precio) + "<br/>";
    productPrice.innerHTML += "<b>Marca: </b>" + product.marca + "<br/>";
    productPrice.innerHTML += "<b>Empresa: </b>" + product.empresa + "<br/>";

    productPrice.innerHTML += "<b>Fecha de actualización: </b>" +
      parseDate(product.fecha)
      + "<br/>";

    linkProduct.appendChild(productCard);
    productCard.appendChild(productCardBody);
    productCardBody.appendChild(productPrice);

    table.appendChild(linkProduct);
  }

  return table;
}