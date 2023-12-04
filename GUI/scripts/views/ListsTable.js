import { query } from '/scripts/Fetch.js'

export const creatMyListTable = (lists) => {
  const container = document.createElement("div");
  container.className = "container mt-4";

  const row = document.createElement("div");
  row.className = "row";

  for (const list of lists) {
    const col = document.createElement("div");
    col.className = "col-12 col-md-6 mb-4";

    const card = document.createElement("div");
    card.className = "card colshop-card";

    const cardBody = document.createElement("div");
    cardBody.className = "card-body";

    const name = document.createElement("p");
    name.className = "card-text";
    name.innerHTML = `<b>Mi lista:</b> ${list.lis_nombre}`;

    const creationDate = document.createElement("p");
    creationDate.className = "card-text";
    creationDate.innerHTML = `<b> Fecha de Creación:</b> ${list.lis_fecha_creacion}`;

    const lastActivity = document.createElement("p");
    lastActivity.className = "card-text";
    lastActivity.innerHTML = `<b>Última Actualización:</b> ${list.lis_ultima_act}`;

    // Button "Borrar Lista"
    const deleteButton = document.createElement("button");
    deleteButton.className = "btn colshop-press-btn";
    deleteButton.innerText = "Borrar Lista";

    deleteButton.onclick = async (event) => {
      const listName = list.lis_nombre; // Obtaining list name
      const confirmDelete = confirm(`¿Estás seguro de que deseas borrar la lista "${listName}"?`);

      if (confirmDelete) {
        try {
          const deleteListResponse = await query(
            `delete_list?list_name=${listName}`,
            null, 'DELETE'
          );

          // Verificar si la eliminación fue exitosa
          if (deleteListResponse.success) {
            alert(`La lista "${listName}" se ha eliminado exitosamente.`);

            window.onload();
          } else {
            alert(`Error al intentar borrar la lista "${listName}".`);
          }
        } catch (error) {
          console.error('Error al intentar borrar la lista:', error);
          alert(`Error al intentar borrar la lista "${listName}".`);
        }
      }
    };

    // Construir la estructura del card
    cardBody.appendChild(name);
    cardBody.appendChild(creationDate);
    cardBody.appendChild(lastActivity);
    cardBody.appendChild(deleteButton);

    // Verify if the list has something
    if (list.lis_contents && list.lis_contents.length > 0) {
      const productList = document.createElement("ul");
      productList.className = "list-group";

      for (const product of list.lis_contents) {
        const listItem = document.createElement("li");
        listItem.className = "list-group-item colshop-list-item";

        // Info about product
        const productInfo = document.createElement("div");
        productInfo.innerHTML = `<b>Producto:</b> ${product.nombre}`;


        // Button "Borrar Producto"
        const deleteProductButton = document.createElement("button");
        deleteProductButton.className = "btn btn-outline-danger colshop-press-btn-altern btn-sm ml-2";
        deleteProductButton.innerText = "Borrar Producto";
        const productId = product.id; // Obtaining list name

        deleteProductButton.onclick = async () => {
          const confirmDeleteProduct = confirm(`¿Estás seguro de que deseas borrar el producto "${product.nombre}"?`);

          if (confirmDeleteProduct) {
            const deleteProductButton = await query(
              `delete_product_from_list?list_name=${productId}`,
              null, 'DELETE'
            );

            window.onload();

          }
        };

        // Adding the product info and the delete button to the list item
        listItem.appendChild(productInfo);
        listItem.appendChild(deleteProductButton);

        // Agregar listItem al productList
        productList.appendChild(listItem);
      }

      // Agregar productList al cardBody
      cardBody.appendChild(productList);
    }

    // Agregar cardBody al card
    card.appendChild(cardBody);

    // Agregar card al col
    col.appendChild(card);

    // Agregar col al row
    row.appendChild(col);
  }
  console.log(lists)

  // Agregar row al container
  container.appendChild(row);

  return container;
};
