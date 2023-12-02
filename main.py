from user_login import *
from upload_data import *
from fastapi.middleware.cors import CORSMiddleware



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
origins = [
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# All products in the database
@app.get("/get_all_products")
async def get_all_products():
    try:
        # Crear un cursor para ejecutar consultas SQL
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Ejecutar la consulta SQL
        cursor.execute("SELECT pro_ID, pro_nombre, pro_marca FROM PRODUCTO")

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
       connection = get_mysql_connection()
       cursor = connection.cursor()
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
        connection = get_mysql_connection()
        cursor = connection.cursor()
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
        connection = get_mysql_connection()
        cursor = connection.cursor()
        
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
        connection = get_mysql_connection()
        cursor = connection.cursor()

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
async def delete_review(pro_id: str, id_autoinc: int):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()
        # Call the stored procedure
        cursor.callproc('sp_delete_reseña', [pro_id, id_autoinc])
        # Commit the changes to the database
        connection.commit()
        return {"message": "Review deleted successfully"}

    except Exception as e:
        print(f"Error: {e}")

@app.post("/create_review")
async def create_review(pro_id: str, calificacion: int, comentario: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()
        id_autoinc = None

        # Call the stored procedure
        result = cursor.callproc('sp_create_reseña', [pro_id, calificacion, comentario, id_autoinc])

        # Fetch the OUT parameter value
        id_autoinc = result[3]

        # Commit the changes to the database
        connection.commit()

        return {"message": "Review created successfully", "id_autoinc": id_autoinc}

    except Exception as e:
        print(f"Error: {e}")

@app.get("/create_list")
async def create_list(list_name: str, privada: int):
   try:
       connection = get_mysql_connection()
       cursor = connection.cursor()
       print(f"Creating list: {list_name}")
       cursor.callproc('sp_create_list', [list_name, privada])
       connection.commit()
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
    
    # Establish connection from authenticated user
    mysql_config["user"] = form_data.username
    mysql_config["password"] = form_data.password
    connection = get_mysql_connection()
    try:
        cursor = connection.cursor()
        cursor.callproc('sp_create_session')
        connection.commit()
        response = {"message": "Successfully created session"}
    except Exception as e:
       print(f"Error: {e}")
       response = {"message": "Error creating the list.Details: {str(e)}"}

    return {"access_token": access_token, "token_type": "bearer", "message": response}


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

@app.get("/view_list")
async def view_list(username: str, list_name: str):
    try:
        # Crear un cursor
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc('sp_view_list', [username, list_name])

        # Obtener los resultados
        result = None
        for answer in cursor.stored_results():
            result = answer.fetchall()

        # Cerrar el cursor
        cursor.close()

        # Comprobar si se encontraron resultados
        if result:
            # Crear la respuesta
            response = {"productos": [item[0] for item in result]}
        else:
            response = {"message": "No se encontraron productos en la lista."}

        return response

    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error: {e}")

@app.post("/insert_product_into_list") #check out
async def insert_product_into_list(id: str, list_name: str):
    try:
        # Crear un cursor
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc('sp_insert_product_into_list', [id, list_name])

        # Confirmar cambios en la base de datos
        connection.commit()

        # Cerrar el cursor
        cursor.close()

        # Crear la respuesta
        response = {"message": "Producto insertado correctamente en la lista."}

        return response

    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error: {e}")

@app.post("/create_category")
async def create_category(cat_name: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_create_category', [cat_name])
        connection.commit()
        cursor.close()
        response = {"message": f"Categoría '{cat_name}' creada correctamente."}
        return response

    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error: {e}")

@app.delete("/delete_category")
async def delete_category(cat_name: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_delete_category', [cat_name])
        connection.commit()
        cursor.close()

        response = {"message": f"Categoría '{cat_name}' eliminada correctamente."}

        return response

    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error: {e}")

@app.post("/create_comparacion")
async def create_comparacion():
    try:
        # Crear un cursor
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado sp_create_comparacion
        cursor.callproc('sp_create_comparacion')

        # Obtener el resultado del procedimiento almacenado (id_autoinc)
        id_autoinc = cursor.fetchone()[0]

        # Confirmar cambios en la base de datos
        connection.commit()

        # Cerrar el cursor
        cursor.close()

        # Crear la respuesta
        response = {"message": f"Comparación creada correctamente with id: {id_autoinc}"}

        return response

    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error: {e}")

@app.post("/create_busqueda")
async def create_busqueda(palabras: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_create_busqueda', [palabras])
        id_autoinc = cursor.fetchone()[0]
        connection.commit()
        cursor.close()
        response = {"message": f"Búsqueda creada correctamente with id: {id_autoinc}"}

        return response

    except Exception as e:
        # Manejar errores
        raise HTTPException(status_code=500, detail=f"Error: {e}")

@app.delete("/delete_list")
async def delete_list(list_name: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_delete_list', [list_name])

        connection.commit()

        cursor.close()

        response = {"message": f"Lista '{list_name}' eliminada correctamente."}

        return response

    except Exception as e:


        raise HTTPException(status_code=500, detail=f"Error: {e}")

# Endpoint for the stored procedure sp_GetProductAveragePrice
@app.get("/get_product_average_price/{product_id}")
async def get_product_average_price(product_id: str):
    try:
        # Create a cursor
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Call the MySQL function fn_GetProductAveragePrice
        cursor.execute(f"SELECT fn_GetProductAveragePrice('{product_id}') AS average_price")

        # Retrieve the result
        result = cursor.fetchone()

        # Check if the result is not None
        if result is not None:
            average_price = result[0]

            # Close the cursor
            cursor.close()

            # Create the response
            response = {"average_price": average_price}

            return response
        else:
            # Handle the case where the result is None
            raise HTTPException(status_code=404, detail="Product not found")

    except Exception as e:
        # Handle other errors
        raise HTTPException(status_code=500, detail=f"Error: {e}")