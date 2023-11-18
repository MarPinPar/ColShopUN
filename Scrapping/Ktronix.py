import csv
import time
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
import undetected_chromedriver as uc
import datetime
def searchProduct(keyWord, data_product: dict, driver: webdriver.Chrome) -> dict:
    driver.get("https://www.ktronix.com/")
    print(driver.title)

    search_bar = driver.find_element(by=By.ID, value="js-site-search-input")
    search_bar.clear()
    search_bar.send_keys(keyWord)
    search_bar.submit()

    last_height = driver.execute_script("return document.body.scrollHeight")
    while True:
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(1)
        new_height = driver.execute_script("return document.body.scrollHeight")
        if new_height == last_height:
            break
        last_height = new_height

    product_total = driver.find_elements(by=By.CLASS_NAME, value="js-product-item")

    titles_products = []
    prices = []
    links = []
    images = []
    marcas_productos = []
    identificador_producto = []


    marcas = ['GE', 'HP', 'LG', 'TCL', 'ROG', 'Xiaomi', 'Kalley', 'Braun', 'Maytag', 'Realme', 'Alcatel', 'Challenger',
              'Alexa', 'Babyliss', 'Honor', 'Nokia', 'Huawei', 'Haceb', 'Panasonic', 'Lenovo', 'Whirlpool', 'MSI',
              'Gama', 'Zte', 'Conair', 'Remington', 'Samsung', 'Oppo', 'Mabe', 'Canon', 'Asus', 'Electrolux', 'iPhone',
              'Philips', 'Acer', 'Acros', 'vivo', 'Motorola', 'Wahl', 'Fujifilm', 'GoPro', 'Google Home', 'Tecno',
              'Legion', 'Moto', 'Apple', 'Nintendo', 'Microsoft', 'Sony']

    products_added = 0

    for product in product_total:

        id_products = product.find_element(by=By.CLASS_NAME, value='js-view-details')
        id_products = id_products.get_attribute("data-id")

        title_product = product.find_element(by=By.CLASS_NAME, value='js-algolia-product-title').text
        price_text = product.find_element(by=By.CLASS_NAME, value='price').text

        if not price_text.strip():
            continue

        price = int(price_text.replace("$", "").replace(".", ""))
        product_link_element = product.find_element(by=By.CSS_SELECTOR, value="a.js-algolia-product-title").get_attribute("href")
        product_image_element = product.find_element(by=By.CSS_SELECTOR, value="img").get_attribute("src")

        marca_encontrada = False
        for marca in marcas:
            if marca.lower() in title_product.lower():
                marcas_productos.append(marca)
                marca_encontrada = True
                break
        if not marca_encontrada:
            marcas_productos.append("Otra")

        titles_products.append(title_product)
        prices.append(price)
        links.append(product_link_element)
        images.append(product_image_element)
        identificador_producto.append(id_products)

        # Increment the count of products added
        products_added += 1

        # Break the loop if three products are added
        if products_added == 4:
            break

    driver.close()

    data_product['titulo'].extend(titles_products)
    data_product['precio'].extend(prices)
    data_product['link'].extend(links)
    data_product['marca'].extend(marcas_productos)
    data_product['imagen'].extend(images)
    data_product['empresa'].extend(["Ktronix"] * len(titles_products))
    data_product['fecha'].extend([datetime.datetime.today()] * len(titles_products))
    data_product['id'].extend(identificador_producto)

    with open('products.csv', 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['Titulo', 'Precio', 'Link', 'Marca', 'Imagen', 'Empresa', 'Fecha','Identificador'])


        # Write the data to the CSV file
        for title, price, link, marca, imagen, empresa, idpro in zip(titles_products, prices, links, marcas_productos, images, ["Ktronix"] * len(titles_products), identificador_producto):
            csv_writer.writerow([title, price, link, marca, imagen, empresa])
            fecha = datetime.datetime.today()
            csv_writer.writerow([title, price, link, marca, imagen, empresa, fecha, idpro])

    return data_product
