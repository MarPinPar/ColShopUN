// Importar las funciones necesarias de Fetch.js y las funciones de las vistas
import { query } from '/scripts/Fetch.js';
import {
    renderProductHistoricalPrices, renderProductReviews,
    renderProductAveragePrice, renderProduct
} from '/scripts/views/historicalProductRenderers.js';

const productParent = document.getElementById('tableProduct');

window.onload = async (event) => {
    const params = new Proxy(new URLSearchParams(window.location.search), {
        get: (searchParams, prop) => searchParams.get(prop),
    });

    const productID = encodeURIComponent(params.product);
    const storeID = encodeURIComponent(params.store);

    const productContainer = document.createElement('div');
    productContainer.className = "row text-center colshop-container";

    // Obtener información del producto
    const productInfo = await query(
        `get_product_info/${productID}`,
        null, 'GET'
    );

    const productTitle = document.createElement('div');
    productTitle.className = "col-12 colshop-title";
    productTitle.innerHTML = `<h1>${productInfo.pro_nombre}</h1>`;
    productContainer.appendChild(productTitle);

    const productInfoDiv = renderProduct(productInfo);
    productContainer.appendChild(productInfoDiv);

    let separatorDiv = document.createElement('div');
    separatorDiv.className = "col-12 colshop-general-separator";
    productContainer.appendChild(separatorDiv);

    // Obtener precios históricos
    const historicalPrices = await query(
        `get_prices_by_history?product_id=${productID}&store_id=${storeID}`,
        null, 'GET'
    );

    const productPricesDiv = renderProductHistoricalPrices(historicalPrices);
    productContainer.appendChild(productPricesDiv);

    separatorDiv = document.createElement('div');
    separatorDiv.className = "col-12 colshop-general-separator";
    productContainer.appendChild(separatorDiv);

    // Obtener precio promedio
    const averagePrice = await query(
        `get_product_average_price/${productID}`,
        null, 'GET'
    );

    const averagePriceDiv = renderProductAveragePrice(averagePrice);
    productContainer.appendChild(averagePriceDiv);

    separatorDiv = document.createElement('div');
    separatorDiv.className = "col-12 colshop-general-separator";
    productContainer.appendChild(separatorDiv);

    // Obtener reviews
    const historicalReviews = await query(
        `get_reviews_by_product?product_id=${productID}`,
        null, 'GET'
    );

    const productReviewsDiv = renderProductReviews(productInfo.pro_ID, historicalReviews);
    productContainer.appendChild(productReviewsDiv);

    productParent.appendChild(productContainer);
};
