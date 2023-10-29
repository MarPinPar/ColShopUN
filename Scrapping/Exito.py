from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv
import datetime



def searchProduct(keyWord, data_product : dict, driver : webdriver.Chrome) -> dict:

    driver.get("https://www.exito.com/")
    print(driver.title)


    # Esperar a que el elemento esté presente
    time.sleep(5)
    search_bar = driver.find_element(By.TAG_NAME, "input")
    search_bar.clear()
    search_bar.send_keys(f"{keyWord}")
    search_bar.send_keys(Keys.RETURN)



    last_height = driver.execute_script("return document.body.scrollHeight")
    while True:
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(5)
        new_height = driver.execute_script("return document.body.scrollHeight")
        if new_height == last_height:
                time.sleep(5)
                break
        last_height = new_height

    product_total: list = driver.find_elements(by=By.CLASS_NAME, value = "vtex-product-summary-2-x-container")
    prices = []
    titles_products = []
    links = []
    links_product = []
    marcas_productos = []
    identificador_producto = []

    marcas = ['GE', 'HP', 'LG', 'TCL', 'ROG', 'Xiaomi', 'Kalley', 'Braun', 'Maytag', 'Realme', 'Alcatel', 'Challenger',
              'Alexa', 'Babyliss',
              'Honor', 'Nokia', 'Huawei', 'Haceb', 'Panasonic', 'Lenovo', 'Whirlpool', 'MSI', 'Gama',
              'Zte', 'Conair', 'Remington', 'Samsung', 'Oppo', 'Mabe', 'Canon', 'Asus', 'Electrolux', 'iPhone',
              'Philips',
              'Acer', 'Acros', 'vivo', 'Motorola', 'Wahl', 'Fujifilm', 'GoPro', 'Google Home', 'Tecno', 'Legion',
              'Moto', 'Apple', 'Nintendo', 'Microsoft', 'Sony']

    for product in product_total:
        article = product.find_element(By.TAG_NAME, 'article')
        id_product = article.get_attribute('data-fs-product-card-sku')

        title_products = product.find_element(By.CLASS_NAME, value = 'vtex-store-components-3-x-productBrand')
        title_products = title_products.text

        price_element = product.find_element(By.CLASS_NAME, "exito-vtex-components-4-x-currencyContainer")
        price_element = int(price_element.text.replace("$", "").replace(".", "").replace(" ",""))

        link_element = product.find_element(By.CLASS_NAME, "vtex-product-summary-2-x-imageNormal")
        link_element = link_element.get_attribute("src")

        link = product.find_element(By.CLASS_NAME, 'vtex-product-summary-2-x-clearLink')
        link = link.get_attribute("href")



        marca_encontrada = False
        for marca in marcas:
            if marca.lower() in title_products.lower():
                marcas_productos.append(marca)
                marca_encontrada = True
                break
        if not marca_encontrada:
            marcas_productos.append("Otra")

        titles_products.append(title_products)
        prices.append(price_element)
        links.append(link_element)
        links_product.append(link)
        identificador_producto.append(id_product)

    data_product['titulo'].extend(titles_products)
    data_product['precio'].extend(prices)
    data_product['link'].extend(links)
    data_product['marca'].extend(marcas_productos)
    data_product['imagen'].extend(links_product)
    data_product['empresa'].extend(["Exito"] * len(titles_products))
    data_product['fecha'].extend([datetime.datetime.today()] * len(titles_products))
    data_product['id'].extend(identificador_producto)


    with open('products.csv', 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['Titulo', 'Precio', 'Link', 'Marca', 'Imagen', 'Empresa', 'Fecha', 'Identificador'])

        for title, price, link, marca, imagen, empresa, idpro in zip(titles_products, prices, links, marcas_productos, links,
                                                              ["Exito"] * len(titles_products), identificador_producto):
            fecha = datetime.datetime.today()
            csv_writer.writerow([title, price, link, marca, imagen, empresa, fecha,idpro])


    driver.quit()
    return data_product



