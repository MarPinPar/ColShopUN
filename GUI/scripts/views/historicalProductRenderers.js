import { query } from '/scripts/Fetch.js';
import { parseDate, parsePrice } from '/scripts/utils.js';

export const renderProductHistoricalPrices = (prices) => {
  const container = document.createElement("div");
  container.className = "col-12 mt-4";

  const row = document.createElement("div");
  row.className = "row";

  const title = document.createElement("div");
  title.className = "col-12 colshop-subtitle";
  title.innerHTML = `<h3>Precios históricos</h3>`;
  row.appendChild(title);

  if (prices.status === 500 || prices.message || prices.error || !prices[0]) {
    const noData = document.createElement("div");
    noData.className = "col-12";
    noData.textContent = "No hay precios históricos";
    row.appendChild(noData);

    container.appendChild(row);

    return container;
  }

  for (const index in prices) {
    const historicalPrice = prices[index];

    if (!historicalPrice || isNaN(parseInt(index))) continue;

    const col = document.createElement("div");
    col.className = "col-12 col-md-3 mb-4";

    const card = document.createElement("div");
    card.className = "card colshop-card";

    const cardBody = document.createElement("div");
    cardBody.className = "card-body";

    const price = document.createElement("p");
    price.className = "card-text";
    price.innerHTML = `<b>Precio:</b> ${parsePrice(historicalPrice.pre_valor)}`;

    const date = document.createElement("p");
    date.className = "card-text";
    date.innerHTML = `<b>Fecha:</b> ${parseDate(historicalPrice.pre_fechaHora)}`;

    // Construir la estructura del card
    cardBody.appendChild(price);
    cardBody.appendChild(date);

    card.appendChild(cardBody);
    col.appendChild(card);
    row.appendChild(col);
  }

  container.appendChild(row);

  return container;
};

export const renderProductAveragePrice = (price) => {
  const container = document.createElement("div");
  container.className = "col-12 mt-4";

  const row = document.createElement("div");
  row.className = "row";

  const title = document.createElement("div");
  title.className = "col-12 colshop-subtitle";
  title.innerHTML = `<h3>Precio promedio</h3>`;
  row.appendChild(title);

  const dataToDisplay = price.average_price ? parsePrice(price.average_price) : "No hay precio promedio";

  const data = document.createElement("div");
  data.className = "col-12";
  data.style.fontSize = "30px"
  data.innerHTML = `<p>${dataToDisplay}</p>`;
  row.appendChild(data);

  container.appendChild(row);

  return container;
}

export const renderProductReviews = (proID, reviews) => {
  const container = document.createElement("div");
  container.className = "col-12 mt-4";

  const row = document.createElement("div");
  row.className = "row";

  const title = document.createElement("div");
  title.className = "col-12 colshop-subtitle";
  title.innerHTML = `<h3>Reseñas</h3>`;
  row.appendChild(title);

  const reviewsList = reviews.reviews;

  console.log(reviewsList);

  const addReview = (review) => {
    const col = document.createElement("div");
    col.className = "col-12 col-md-3 mb-4";

    const card = document.createElement("div");
    card.className = "card review-card";

    const cardBody = document.createElement("div");
    cardBody.className = "card-body review-card-body";

    const calification = document.createElement("p");
    calification.className = "card-text";
    calification.innerHTML = `<b>Calificación:</b> ${review.res_calificacion}`;

    const description = document.createElement("p");
    description.className = "card-text";
    description.innerHTML = `<b>Comentario:</b> ${review.res_comentario}`;

    // Construir la estructura del card
    cardBody.appendChild(calification);
    cardBody.appendChild(description);

    card.appendChild(cardBody);
    col.appendChild(card);
    row.appendChild(col);
  }

  if (reviews.status === 500 || reviews.message || reviews.error || !reviewsList[0]) {
    const noData = document.createElement("div");
    noData.className = "col-12";
    noData.textContent = "No hay reseñas";
    row.appendChild(noData);

  } else {
    for (const index in reviewsList) {
      const review = reviewsList[index];

      if (!review || isNaN(parseInt(index))) continue;

      addReview(review);
    }
  }

  container.appendChild(row);

  // Controls for adding reviews
  const addReviewCol = document.createElement("div");
  addReviewCol.className = "col-12 text-center";

  const addReviewColTitle = document.createElement("div");
  addReviewColTitle.className = "col-12 colshop-subtitle";
  addReviewColTitle.innerHTML = `<h4>Agregar reseña</h4>`;
  addReviewCol.appendChild(addReviewColTitle);

  const addReviewColCalification = document.createElement("input");
  addReviewColCalification.className = "form-control";
  addReviewColCalification.style.marginBottom = "10px";
  addReviewColCalification.style.marginLeft = "25%";
  addReviewColCalification.style.width = "50%";
  addReviewColCalification.placeholder = "Calificación";
  addReviewColCalification.type = "number";
  addReviewColCalification.min = 0;
  addReviewColCalification.max = 5;
  addReviewCol.appendChild(addReviewColCalification);

  const addReviewColComentario = document.createElement("textarea");
  addReviewColComentario.className = "form-control";
  addReviewColComentario.placeholder = "Comentario";
  addReviewCol.appendChild(addReviewColComentario);

  const addReviewColButton = document.createElement("button");
  addReviewColButton.className = "btn colshop-press-btn";
  addReviewColButton.textContent = "Agregar reseña";

  addReviewColButton.onclick = async () => {
    const calificacion = encodeURIComponent(addReviewColCalification.value);
    const comentario = encodeURIComponent(addReviewColComentario.value);
    const productID = encodeURIComponent(proID);

    const result = await query(
      `create_review?pro_id=${productID}&calificacion=${calificacion}&comentario=${comentario}`,
      null,
      'POST'
    );

    if (result.status === 500) {
      return;
    }

    console.log(result);

    addReview({
      res_calificacion: addReviewColCalification.value,
      res_comentario: addReviewColComentario.value,
    });


  }
  addReviewCol.appendChild(addReviewColButton);

  container.appendChild(addReviewCol);

  return container;
}

export const renderProduct = (product) => {
  const productContainer = document.createElement("div");
  productContainer.className = "col-12";

  if (product.error || product.message || product.status === 500) {
    const noData = document.createElement("div");
    noData.className = "col-12";
    noData.textContent = "No hay información del producto";
    productContainer.appendChild(noData);

    return productContainer;
  }

  const card = document.createElement("div");
  card.className = "card colshop-card";

  const img = document.createElement("img");
  img.className = "card-img-top align-self-center mx-auto";
  img.src = product.pre_imagen;
  img.alt = "Product Image";
  img.style.width = "300px";
  img.style.height = "auto";

  const cardBody = document.createElement("div");
  cardBody.className = "card-body";

  const title = document.createElement("h5");
  title.className = "card-title colshop-general-text";
  title.textContent = product.pro_nombre;

  const text = document.createElement("p");
  text.className = "card-text colshop-general-text";
  text.innerHTML = `<b>Marca:</b> ${product.pro_marca}<br/><b>Precio:</b> ${parsePrice(product.pre_valor)} `;

  // Agregar elementos al cardBody
  cardBody.appendChild(title);
  cardBody.appendChild(text);

  const separatorDiv = document.createElement('div');
  separatorDiv.className = "col-12 colshop-general-separator";
  cardBody.appendChild(separatorDiv);

  const listSelectionTitle = document.createElement("h5");
  listSelectionTitle.className = "card-title colshop-general-text";
  listSelectionTitle.textContent = "Agregar a lista";

  cardBody.appendChild(listSelectionTitle);

  (
    async () => {
      // Agregar botón "Agregar a la lista"
      let lists = document.createElement("select");
      lists.className = "form-select colshop-combobox";

      const listsResponse = await query(
        `get_mis_listas`,
        null,
        'GET'
      );

      if (listsResponse.message || listsResponse.status === 500 || !listsResponse[0]) {

        lists = document.createElement("p");
        lists.textContent = "No tienes listas";
        cardBody.appendChild(lists);
        return;
      }

      for (const index in listsResponse) {
        const list = listsResponse[index];

        if (!list || isNaN(parseInt(index))) continue;

        const option = document.createElement("option");
        option.value = list.lis_nombre;
        option.textContent = list.lis_nombre;
        lists.appendChild(option);
      }

      const listContainer = document.createElement("div");
      listContainer.appendChild(lists);
      cardBody.appendChild(listContainer);


      const button = document.createElement("button");
      button.className = "btn colshop-press-btn";
      button.textContent = "Agregar a la lista";

      button.onclick = async () => {
        const listID = encodeURIComponent(lists.value);

        const response = await query(
          `insert_product_into_list?id=${product.pro_ID}&list_name=${listID} `,
          null,
          'POST'
        );
      };

      cardBody.appendChild(button);
    }
  )();

  // Agregar elementos al card
  card.appendChild(img);
  card.appendChild(cardBody);

  productContainer.appendChild(card);

  return productContainer;
};