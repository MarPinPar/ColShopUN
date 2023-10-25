import csv
from selenium import webdriver
from selenium.webdriver.common.by import By
import datetime

def searchProduct(keyWord, data_product: dict, driver: webdriver.Chrome) -> dict:

    driver.get("https://www.mercadolibre.com.co/")
    print(driver.title)

    search_bar = driver.find_element(by=By.CLASS_NAME, value="nav-search-input")
    search_bar.clear()
    search_bar.send_keys(f"{keyWord}")
    search_bar.submit()
    product_total = driver.find_elements(by=By.CLASS_NAME, value="ui-search-layout__item")

    titles_products = []
    prices = []
    links_products = []
    image_urls = []
    marcas_productos = []

    marcas = ['GE', 'HP', 'LG', 'TCL', 'ROG', 'Xiaomi', 'Kalley', 'Braun', 'Maytag', 'Realme', 'Alcatel', 'Challenger',
              'Alexa', 'Babyliss', 'Honor', 'Nokia', 'Huawei', 'Haceb', 'Panasonic', 'Lenovo', 'Whirlpool', 'MSI', 'Gama',
              'Zte', 'Conair', 'Remington', 'Samsung', 'Oppo', 'Mabe', 'Canon', 'Asus', 'Electrolux', 'iPhone',
              'Philips', 'Acer', 'Acros', 'vivo', 'Motorola', 'Wahl', 'Fujifilm', 'GoPro', 'Google Home', 'Tecno', 'Legion',
              'Moto', 'Apple', 'Nintendo', 'Microsoft', 'Sony']

    for product in product_total:
        price_products = product.find_element(by=By.CLASS_NAME, value='ui-search-price__second-line')
        price = price_products.find_element(by=By.CLASS_NAME, value='andes-money-amount__fraction')
        price = int(price.text.replace("$", "").replace(".", ""))

        title_product = product.find_element(by=By.CLASS_NAME, value="ui-search-item__title")
        title_product = title_product.text

        link_product = product.find_element(by=By.CLASS_NAME, value="ui-search-link")
        link_product = link_product.get_attribute("href")

        image_products = driver.find_element(by=By.CLASS_NAME, value='ui-search-result-image__element')
        image_products = image_products.get_attribute("src")

        marca_encontrada = False
        for marca in marcas:
            if marca.lower() in title_product.lower():
                marcas_productos.append(marca)
                marca_encontrada = True
                break
        if not marca_encontrada:
            marcas_productos.append("Otra")

        prices.append(price)
        titles_products.append(title_product)
        links_products.append(link_product)
        image_urls.append(image_products)

    data_product['titulo'].extend(titles_products)
    data_product['precio'].extend(prices)
    data_product['link'].extend(links_products)
    data_product['marca'].extend(marcas_productos)
    data_product['imagen'].extend(image_urls)
    data_product['empresa'].extend(["Mercado Libre"] * len(titles_products))
    data_product['fecha'].extend([datetime.datetime.today()] * len(titles_products))

    # Initialize a CSV file for writing
    with open('products.csv', 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)


        # Write the CSV header
        csv_writer.writerow(['Titulo', 'Precio', 'Link', 'Marca', 'Imagen', 'Empresa', 'Fecha'])

        # Write the data to the CSV file
        for title, price, link, marca, imagen, empresa in zip(titles_products, prices, links_products, marcas_productos, image_urls, ["Mercado Libre"] * len(titles_products)):
            csv_writer.writerow([title, price, link, marca, imagen, empresa])
            fecha = datetime.datetime.today()
            csv_writer.writerow([title, price, link, marca, imagen, empresa, fecha])
    return data_product
