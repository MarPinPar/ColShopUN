import undetected_chromedriver as uc
import pandas as pd
from Scrapping import Exito, Ktronix, MercadoLibre  # Importing custom scraping modules
import mysql.connector
from sqlalchemy import create_engine, outparam
from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import sessionmaker, declarative_base, relationship
from fastapi import FastAPI
from jose import JWTError, jwt
from passlib.context import CryptContext
from decouple import config

SECRET_KEY = config('SECRET_KEY')

ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 30

app = FastAPI()  # Create a FastAPI application
app.title = "ColShop Database 2023-2"  #  application title

# MySQL database connection configuration
mysql_config = {
    "host": config('MYSQL_HOST'),
    "user": config('MYSQL_USER'),
    "password": config('MYSQL_PASSWORD'),
    "database": config('MYSQL_DATABASE'),
}

# Establish a MySQL connection
conn = mysql.connector.connect(**mysql_config)
@app.get("/get_all_products")
async def get_all_products():
    try:
        # Crear un cursor para ejecutar consultas SQL
        cursor = conn.cursor()

        # Ejecutar la consulta SQL
        cursor.execute("SELECT * FROM PRODUCTO")

        # Obtener todos los resultados
        productos = cursor.fetchall()

        # Convertir los resultados a un formato que se puede enviar como respuesta JSON
        result = [{"pro_ID": pro_ID, "pro_nombre": pro_nombre, "pro_marca": pro_marca} for pro_ID, pro_nombre, pro_marca in productos]
        return {"productos": result}

    finally:
        # Cerrar el cursor (la conexión se cerrará en el evento de apagado)
        cursor.close()

@app.on_event("shutdown")
def shutdown_event():
    # Close the MySQL connection when the application shuts down
    conn.close()

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

    result = df.to_dict(orient="records")

    # Insert the data into the MySQL database
    insert_data_into_database(df)

    return {"result": result}  # Return the search results as JSON
# Cambia el nombre del parámetro de product_to_search a product_name

@app.get("/get_lowest_price")
async def get_lowest_price(product_name: str):
   try:
       cursor = conn.cursor()
       print(f"Searching for product: {product_name}")
       result = cursor.callproc('sp_GetLowestPriceByProductName',[product_name])
       for answer in cursor.stored_results():
           result = answer.fetchall()
       print(result)
       if result:
           response = {"tie_nombre": result[0][0], "pre_valor": result[0][1]}
       else:
           response = {"message": "No se encontró información para el producto."}
       return response

   except Exception as e:
       print(f"Error: {e}")


@app.get("/get_prices_by_search")
async def get_prices_by_search(search_term: str):
    try:
        cursor = conn.cursor()
        print(f"Searching for products with term: {search_term}")
        result = cursor.callproc('sp_GetPricesForProductsBySearch', [search_term])
        for answer in cursor.stored_results():
            result = answer.fetchall()
        print(result)
        if result:
            response = [{"tie_nombre": row[0], "pro_nombre": row[1], "pre_valor": row[2], "pre_fechaHora": row[3]} for row in result]
        else:
            response = {"message": "No se encontró información para el término de búsqueda."}
        return response

    except Exception as e:
        print(f"Error: {e}")

def insert_data_into_database(df):
    cursor = conn.cursor()
    # Loop through the DataFrame and insert data into the PRODUCTO table
    for index, row in df.iterrows():
        pro_ID = row['id']
        pro_nombre = row['titulo']
        pro_marca = row['marca']
        # Insert data into PRODUCTO table
        cursor.callproc('sp_InsertDataIntoProducto', (pro_ID, pro_nombre, pro_marca))
    conn.commit()
    cursor.close()

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

