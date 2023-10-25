import csv
import time
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
import undetected_chromedriver as uc
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

    marcas = ['GE', 'HP', 'LG', 'TCL', 'ROG', 'Xiaomi', 'Kalley', 'Braun', 'Maytag', 'Realme', 'Alcatel', 'Challenger',
              'Alexa', 'Babyliss', 'Honor', 'Nokia', 'Huawei', 'Haceb', 'Panasonic', 'Lenovo', 'Whirlpool', 'MSI',
              'Gama', 'Zte', 'Conair', 'Remington', 'Samsung', 'Oppo', 'Mabe', 'Canon', 'Asus', 'Electrolux', 'iPhone',
              'Philips', 'Acer', 'Acros', 'vivo', 'Motorola', 'Wahl', 'Fujifilm', 'GoPro', 'Google Home', 'Tecno',
              'Legion', 'Moto', 'Apple', 'Nintendo', 'Microsoft', 'Sony']

    for product in product_total:
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

    driver.close()

    data_product['titulo'].extend(titles_products)
    data_product['precio'].extend(prices)
    data_product['link'].extend(links)
    data_product['marca'].extend(marcas_productos)
    data_product['imagen'].extend(images)
    data_product['empresa'].extend(["Ktronix"] * len(titles_products))

    with open('products.csv', 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)

        # Write the CSV header
        csv_writer.writerow(['Titulo', 'Precio', 'Link', 'Marca', 'Imagen', 'Empresa'])

        # Write the data to the CSV file
        for title, price, link, marca, imagen, empresa in zip(titles_products, prices, links, marcas_productos, images, ["Ktronix"] * len(titles_products)):
            csv_writer.writerow([title, price, link, marca, imagen, empresa])

    return data_product