from user_login import *
from upload_data import *

# MySQL database connection configuration
mysql_config = {
    "host": config('MYSQL_HOST'),
    "user": config('MYSQL_USER'),
    "password": config('MYSQL_PASSWORD'),
    "database": config('MYSQL_DATABASE'),
}

# Establish a MySQL connection
conn = mysql.connector.connect(**mysql_config)

# Function to get a MySQL connection
def get_mysql_connection():
    return mysql.connector.connect(**mysql_config)


app = FastAPI()  # Create a FastAPI application
app.title = "ColShop Database 2023-2"  #  application title

# All products in the database
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
    chromedriver_path = config('CHROMEDRIVER_PATH')  # Path to ChromeDriver executable
    output_csv_path = 'products.csv'  # Path to the output CSV file

    # Call the unified_product_search function to perform product search and save results to a CSV
    unified_product_search(product_to_search, chromedriver_path, output_csv_path)

    # Read the results from the CSV into a Pandas DataFrame
    df = pd.read_csv(output_csv_path)

    result = df.to_dict(orient="records")

    # Insert the data into the MySQL database
    insert_data_into_database(df)

    return {"result": result}  # Return the search results as JSON


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


@app.get("/get_prices_by_history")
async def get_prices_by_search_history(product_id: str, store_id: int):
    try:
        # Assuming you have 'conn' as the database connection
        cursor = conn.cursor()
        print(f"Searching for products with term: {product_id}")
        print(f"Searching for products with term: {store_id}")
        # Call the stored procedure
        cursor.callproc('sp_GetPriceHistoryForProductInStore', [product_id, store_id])

        # Fetch the results from the stored procedure
        for result in cursor.stored_results():
            price_history = result.fetchall()

        # Check if there are results
        if price_history:
            response = [{"pre_valor": row[0], "pre_fechaHora": row[1]} for row in price_history]
        else:
            response = {"message": "No se encontró información para el término de búsqueda."}

        return response

    except Exception as e:
        print(f"Error: {e}")

@app.get("/get_most_recent_price")
async def get_most_recent_price(partial_product_name: str):
    try:

        cursor = conn.cursor()
        print(f"Searching for products with term: {partial_product_name}")

        # Call the stored procedure
        cursor.callproc('sp_getMostRecentPriceByProductName', [partial_product_name])

        # Fetch the results from the stored procedure
        for result in cursor.stored_results():
            recent_prices = result.fetchall()

        # Check if there are results
        if recent_prices:
            response = [{"pro_nombre": row[0], "tie_nombre": row[1], "pre_valor": row[2], "pre_fechaHora": row[3]} for row in recent_prices]
        else:
            response = {"message": "No se encontró información para el término de búsqueda."}
        return response

    except Exception as e:
        print(f"Error: {e}")


@app.delete("/delete_review")
async def delete_review(pro_id: int, id_autoinc: int):
    try:
        cursor = conn.cursor()
        # Call the stored procedure
        cursor.callproc('sp_delete_reseña', [pro_id, id_autoinc])
        # Commit the changes to the database
        conn.commit()
        return {"message": "Review deleted successfully"}

    except Exception as e:
        print(f"Error: {e}")

@app.post("/create_review")
async def create_review(pro_id: int, calificacion: int, comentario: str):
    try:
        cursor = conn.cursor()

        # Call the stored procedure
        cursor.callproc('sp_create_reseña', [pro_id, calificacion, comentario])

        # Fetch the OUT parameter value
        for result in cursor.stored_results():
            id_autoinc = result.fetchone()[0]

        # Commit the changes to the database
        conn.commit()

        return {"message": "Review created successfully", "id_autoinc": id_autoinc}

    except Exception as e:
        print(f"Error: {e}")

@app.get("/create_list")
async def create_list(list_name: str, privada: int):
   try:
       cursor = conn.cursor()
       print(f"Creating list: {list_name}")
       cursor.callproc('sp_create_list', [list_name, privada])
       conn.commit()
       response = {"message": "List created successfully."}
       return response

   except Exception as e:
       print(f"Error: {e}")
       response = {"message": "Error creating the list.Details: {str(e)}"}
       return response

#user
@app.post("/token")
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Incorrect username or password", headers={"WWW-Authenticate": "Bearer"})
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": user["us_username"]}, expires_delta=access_token_expires)
    # Aqui
    
    return {"access_token": access_token, "token_type": "bearer"}


@app.get("/users/me/")
async def read_users_me(current_user: dict = Depends(get_current_active_user)):
    return current_user


@app.get("/users/me/items")
async def read_own_items(current_user: dict = Depends(get_current_active_user)):
    return [{"item_id": 1, "owner": current_user}]


@app.post("/create_user")
async def create_user(username: str, alias: str, correo: str, pswd: str):
    hashed_password = get_password_hash(pswd)

    connection = get_mysql_connection()
    try:
        cursor = connection.cursor()
        cursor.callproc('sp_create_user', [username, alias, correo, hashed_password])
        cursor.callproc('sp_createDBuser', [username, pswd])
        connection.commit()

        # Check if the user was created successfully
        created_user = get_user(username)
        if created_user:
            # Grant 'usuario' role to the user
            return {"message": "User created successfully", "user_info": created_user}
        else:
            return {"error": "Failed to retrieve user information after creation"}

    except Exception as e:
        return {"error": str(e)}
    finally:
        cursor.close()
        connection.close()


#to run this we have first to give permissions and give the
@app.post("/modify_user")
async def modify_user(new_alias: str = None, new_correo: str = None, new_pswd: str = None):
    connection = get_mysql_connection()
    try:
        cursor = connection.cursor()
        cursor.callproc('sp_modify_user', [new_alias, new_correo, new_pswd])
        connection.commit()
        return {"message": "User modified successfully"}
    except Exception as e:
        return {"error": str(e)}
    finally:
        cursor.close()
        connection.close()



