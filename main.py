from fastapi import FastAPI
import undetected_chromedriver as uc
from selenium import webdriver
import pandas as pd
from Scrapping import Exito, Ktronix, MercadoLibre

app = FastAPI()
app.title = "ColShop Database"

@app.get("/")
async def root():
    return {"message": "Welcome to Colshop, the best prices online in Colombia."}

@app.get("/search_product")

def search_product(product_to_search: str):
    chromedriver_path = '/Users/knsmolina.28/Desktop/Scrapping/chromedriver'  # Provide the path to your ChromeDriver executable
    output_csv_path = 'products.csv'

    unified_product_search(product_to_search, chromedriver_path, output_csv_path)  # Save the results to a CSV
    df = pd.read_csv(output_csv_path)  # Read the results from the CSV

    # Convert the Pandas DataFrame to a list of dictionaries
    result = df.to_dict(orient="records")

    return {"result": result}

def unified_product_search(product_to_search, chromedriver_path, output_csv_path):
    data_product = {"titulo": [], "precio": [], "link": [], "marca": [], "imagen": [], "empresa": [], "fecha":[], 'id':[]}

    def search_and_merge(search_function, data_product, product_to_search):
        driver = reload_driver(chromedriver_path)
        data_product = search_function.searchProduct(product_to_search, data_product, driver)
        driver.quit()

    search_functions = [MercadoLibre, Ktronix]

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
