from fastapi import FastAPI
import undetected_chromedriver as uc
from selenium import webdriver
import pandas as pd
from Scrapping import Exito, Ktronix, MercadoLibre  # Importing custom scraping modules

app = FastAPI()  # Create a FastAPI application
app.title = "ColShop Database, Nataly"  #  application title

@app.get("/")
async def root():
    return {"message": "Welcome to Colshop, the best prices online in Colombia."}
    # This is the root endpoint of the FastAPI application, which returns a welcome message when accessed.

@app.get("/search_product")
async def search_product(product_to_search: str):
    chromedriver_path = '/Users/knsmolina.28/Desktop/Scrapping/chromedriver'  # Path to ChromeDriver executable
    output_csv_path = 'products.csv'  # Path to the output CSV file

    # Call the unified_product_search function to perform product search and save results to a CSV
    unified_product_search(product_to_search, chromedriver_path, output_csv_path)

    # Read the results from the CSV into a Pandas DataFrame
    df = pd.read_csv(output_csv_path)

    # Convert the Pandas DataFrame to a list of dictionaries
    result = df.to_dict(orient="records")

    return {"result": result}  # Return the search results as JSON

def unified_product_search(product_to_search, chromedriver_path, output_csv_path):
    data_product = {"titulo": [], "precio": [], "link": [], "marca": [], "imagen": [], "empresa": [], "fecha": [], 'id': []}
    # Initialize a dictionary to store product data

    def search_and_merge(search_function, data_product, product_to_search):
        driver = reload_driver(chromedriver_path)  # Reload the ChromeDriver with undetected-chromedriver
        data_product = search_function.searchProduct(product_to_search, data_product, driver)  # Perform product search
        driver.quit()

    search_functions = [MercadoLibre, Ktronix]  # List of custom scraping modules

    # Loop through the search functions and perform product searches for each
    for search_function in search_functions:
        search_and_merge(search_function, data_product, product_to_search)

    df = pd.DataFrame(data_product)  # Create a Pandas DataFrame from the collected data
    df.to_csv(output_csv_path, index=False)  # Save the data to a CSV file
    return df  # Return the DataFrame

def reload_driver(chromedriver_path):
    options = uc.ChromeOptions()
    options.add_argument("--headless")  # Configure Chrome to run in headless mode (without GUI)
    driver = uc.Chrome(executable_path=chromedriver_path, options=options)  # Initialize ChromeDriver
    return driver
