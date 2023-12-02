import undetected_chromedriver as uc
import pandas as pd
from Scrapping import Exito, Ktronix, MercadoLibre  # Importing custom scraping modules
import mysql.connector
from sqlalchemy import create_engine, outparam
from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import sessionmaker, declarative_base, relationship
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from decouple import config
from user_login import *

# MySQL database connection configuration
mysql_config = {
    "host": config('MYSQL_HOST'),
    "user": config('MYSQL_USER'),
    "password": config('MYSQL_PASSWORD'),
    "database": config('MYSQL_DATABASE'),
}

# Establish a MySQL connection
conn = mysql.connector.connect(**mysql_config)
def insert_data_into_database(df):
    cursor = conn.cursor()
    # Loop through the DataFrame and insert data into the PRODUCTO table
    for index, row in df.iterrows():
        pro_ID = row['id']
        pro_nombre = row['titulo']
        pro_marca = row['marca']
        # Insert data into PRODUCTO table

        print(pro_ID)
        try:
            cursor.callproc('sp_InsertDataIntoProducto', (pro_ID, pro_nombre, pro_marca))
        except:
            print("Item already exists")
            
        tie_ID = row['idTienda']
        pre_fechaHora = row['fecha']
        pre_valor = row['precio']
        pre_URL = row['link']
        pre_imagen = row['imagen']
        cursor.callproc('sp_InsertDataIntoPrecio', (pro_ID, tie_ID, pre_fechaHora, pre_valor, pre_URL, pre_imagen))

    conn.commit()
    cursor.close()

def unified_product_search(product_to_search, chromedriver_path, output_csv_path):
    data_product = {"titulo": [], "precio": [], "link": [], "marca": [], "imagen": [], "empresa": [], "fecha": [], 'id': [],'idTienda':[]}
    # Initialize a dictionary to store product data
    def search_and_merge(search_function, data_product, product_to_search):
        driver = reload_driver(chromedriver_path)  # Reload the ChromeDriver with undetected-chromedriver
        data_product = search_function.searchProduct(product_to_search, data_product, driver)  # Perform product search
        driver.quit()

    search_functions = [MercadoLibre]  # List of custom scraping modules

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