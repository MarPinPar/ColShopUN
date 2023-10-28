import pandas as pd
import undetected_chromedriver as uc
import Exito, Ktronix, MercadoLibre
def unified_product_search(product_to_search, chromedriver_path, output_csv_path):
    data_product = {"titulo": [], "precio": [], "link": [], "marca": [], "imagen": [], "empresa": [], "fecha":[]}

    def search_and_merge(search_function, data_product, product_to_search):
        driver = reload_driver(chromedriver_path)
        data_product = search_function.searchProduct(product_to_search, data_product, driver)
        driver.quit()

    search_functions = [MercadoLibre, Exito, Ktronix]

    for search_function in search_functions:
        search_and_merge(search_function, data_product, product_to_search)

    df = pd.DataFrame(data_product)
    df.to_csv(output_csv_path, index=False)
    return df

def reload_driver(chromedriver_path):
    options = uc.ChromeOptions()
    options.add_argument("--headless")
    driver = uc.Chrome(executable_path=chromedriver_path, options=options)
    return driver

chromedriver_path = '/Users/knsmolina.28/Desktop/Scrapping/chromedriver'
output_csv_path = 'products.csv'


product_to_search = "Consola PS5 Estándar 825GB"
result = unified_product_search(product_to_search, chromedriver_path, output_csv_path)
print(result)