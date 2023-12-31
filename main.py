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

def reset_my_sql_connection():
    mysql_config["user"] = config('MYSQL_USER')
    mysql_config["password"] = config('MYSQL_PASSWORD')


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
@app.get("/get_product_info/{product_id}")
async def get_product_info(product_id: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Call the stored procedure
        cursor.callproc('GetProductInfo', [product_id])


        # Fetch the results from the stored procedure
        for result in cursor.stored_results():
            product_info = result.fetchall()
            print(result)
        cursor.close()
        connection.close()

        # Check if there are results
        if product_info:
            response = {
                "pro_ID": product_info[0][0],
                "pro_nombre": product_info[0][1],
                "pro_marca": product_info[0][2],
                "tie_ID": product_info[0][3],
                "pre_fechaHora": product_info[0][4].strftime("%Y-%m-%d %H:%M:%S"),
                "pre_valor": product_info[0][5],
                "pre_URL": product_info[0][6],
                "pre_imagen": product_info[0][7]
            }
        else:
            raise HTTPException(status_code=404, detail="Product not found.")

        return response

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

@app.on_event("shutdown")
async def shutdown_event():
    await logout()
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

    # Establish a MySQL connection
    mysql_config = {
        "host": config('MYSQL_HOST'),
        "user": config('MYSQL_USER'),
        "password": config('MYSQL_PASSWORD'),
        "database": config('MYSQL_DATABASE'),
    }

    try:
        await create_busqueda(product_to_search)
    except Exception as e:
        print("No record of search created")

    try:
        # Establish a MySQL connection
        conn = mysql.connector.connect(**mysql_config)

        # Call the unified_product_search function to perform product search and save results to a CSV
        unified_product_search(product_to_search, chromedriver_path, output_csv_path)

        # Read the results from the CSV into a Pandas DataFrame
        df = pd.read_csv(output_csv_path)

        result = df.to_dict(orient="records")

        # Insert the data into the MySQL database
        insert_data_into_database(df, conn)

        # Close the MySQL connection in a finally block to ensure it gets closed even if an exception occurs
        conn.close()

        return {"result": result}
    
    except Exception as e:
       print(f"Error: {e}")
        

@app.get("/get_lowest_price")
async def get_lowest_price(product_name: str):
   try:
       connection = get_mysql_connection()
       cursor = connection.cursor()
       print(f"Searching for product: {product_name}")
       result = cursor.callproc('sp_GetLowestPriceByProductName',[product_name])
       for answer in cursor.stored_results():
           result = answer.fetchall()
       cursor.close()
       connection.close()

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
        cursor.close()
        connection.close()

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
        
        cursor.close()
        connection.close()

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
        
        cursor.close()
        connection.close()

        # Check if there are results
        if recent_prices:
            response = [{"pro_nombre": row[0], "tie_nombre": row[1], "pre_valor": row[2], "pre_fechaHora": row[3]} for row in recent_prices]
        else:
            response = {"message": "No se encontró información para el término de búsqueda."}
        return response

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

        cursor.close()
        connection.close()

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
       cursor.close()
       connection.close()

       response = {"message": "List created successfully."}
       return response

   except Exception as e:
       print(f"Error: {e}")
       response = {"message": "Error creating the list.Details: {str(e)}"}
       return response


@app.delete("/delete_product_from_list")
async def delete_product_from_list(product_id: str, list_name: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        print(f"Deleting product {product_id} from list: {list_name}")
        cursor.callproc('sp_delete_product_from_list', [product_id, list_name])

        # Commit the changes
        connection.commit()

        # Close the cursor and connection
        cursor.close()
        connection.close()

        response = {"message": f"Product {product_id} deleted from list {list_name} successfully."}
        return response

    except Exception as e:
        print(f"Error: {e}")
        response = {"message": f"Error deleting product from list. Details: {str(e)}"}
        return response


@app.delete("/delete_review")
async def delete_review(pro_id: str, id_autoinc: int):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        print(f"Deleting review with PRODUCTO_pro_ID: {pro_id} and ACCION_ac_ID: {id_autoinc}")
        cursor.callproc('sp_delete_reseña', [pro_id, id_autoinc])

        # Commit para confirmar los cambios
        connection.commit()

        # Cerrar el cursor y la conexión
        cursor.close()
        connection.close()

        response = {"message": f"Review deleted successfully for PRODUCTO_pro_ID: {pro_id} and ACCION_ac_ID: {id_autoinc}."}
        return response

    except Exception as e:
        print(f"Error: {e}")
        response = {"message": f"Error deleting review. Details: {str(e)}"}
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
    print(form_data.password)
    connection = get_mysql_connection()
    try:
        global current_session
        current_session = None
        cursor = connection.cursor()
        result = cursor.callproc('sp_create_session', [current_session])
        current_session = result[0]
        print(current_session)

        connection.commit()
        cursor.close()
        response = {"message": "Successfully created session"}
    except Exception as e:
       print(f"Error: {e}")
       response = {"message": "Error creating the list.Details: {str(e)}"}
    
    connection.close()
    return {"access_token": access_token, "token_type": "bearer", "message": response}


@app.post("/logout_user")
async def logout():
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_set_session_end',[current_session])
        globals()["current_session"] = "None"

        cursor.close()
        connection.close()
    except:
        return "Not signed in"
    print("out")


    reset_my_sql_connection()
    return "connection closed"


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
async def modify_user(new_alias: str = None, new_correo: str = None):

    hashed_password = None

    connection = get_mysql_connection()

    try:
        cursor = connection.cursor()
        cursor.callproc('sp_modify_user', [new_alias, new_correo, hashed_password])
        connection.commit()
        cursor.close()
        connection.close()

        temp_mysql_config = {
            "host": config('MYSQL_HOST'),
            "user": config('MYSQL_USER'),
            "password": config('MYSQL_PASSWORD'),
            "database": config('MYSQL_DATABASE'),
            }
        
        connection = mysql.connector.connect(**temp_mysql_config)
        cursor = connection.cursor()

        connection.commit()
        cursor.close()
        connection.close()

        return {"message": "User modified successfully"}
    except Exception as e:

        return {"error": str(e)}

        

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
        connection.close()

        # Comprobar si se encontraron resultados
        if result:
            # Crear la respuesta
            response = [{"id":item[0], "nombre":item[1]} for item in result]
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
        connection.close()

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
        connection.close()
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
        connection.close()

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
        id_autoinc = None

        # Llamar al procedimiento almacenado sp_create_comparacion
        result = cursor.callproc('sp_create_comparacion', [id_autoinc])

        # Obtener el resultado del procedimiento almacenado (id_autoinc)
        id_autoinc = result[0]

        # Confirmar cambios en la base de datos
        connection.commit()

        # Cerrar el cursor
        cursor.close()
        connection.close()

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
        id_autoinc = None

        result = cursor.callproc('sp_create_busqueda', [palabras, id_autoinc])
        id_autoinc = result[1]
        connection.commit()
        cursor.close()
        connection.close()

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
        connection.close()

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

        average_price = None
        # Call the MySQL function fn_GetProductAveragePrice
        result = cursor.callproc('sp_get_avg_price_product', [product_id, average_price])

        average_price = result[1]

        cursor.close()
        connection.close()

        # Create the response
        response = {"average_price": average_price}

        return response

    except Exception as e:
        # Handle other errors
        raise HTTPException(status_code=500, detail=f"Error: {e}")
    

@app.get("/get_mis_listas")
async def get_mis_listas():
    connection = get_mysql_connection()
    cursor = connection.cursor()

    cursor.callproc('sp_get_mis_listas')

    for result in cursor.stored_results():
        mis_listas = result.fetchall()

    cursor.close()
    connection.close()

    if mis_listas:
        response = [{"lis_nombre": row[0], "lis_fecha_creacion": row[1], "lis_privacidad": row[2], "lis_ultima_act": row[3], "lis_autor": row[4], "lis_contents": await view_list(row[4], row[0])} for row in mis_listas]
    else:
        response = {"message": "No se encontraron listas para el usuario."}
    
    return response
    
@app.get("/get_reviews_by_product")
async def get_reviews_by_product(product_id: str):
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_get_review_by_product', [product_id])

        result = []
        for review in cursor.stored_results():
            result.extend(review.fetchall())

        cursor.close()
        connection.close()

        if result:
            reviews = [{"res_calificacion": row[0], "res_comentario": row[1]} for row in result]
            response = {"reviews": reviews}
        else:
            response = {"message": "No se encontró información de reseñas para el producto."}

        return response

    except Exception as e:
        print(f"Error: {e}")
        return {"message": "Error en la solicitud."}


@app.get("/get_search_history")
async def get_search_history():
    try:
        connection = get_mysql_connection()
        cursor = connection.cursor()

        cursor.callproc('sp_get_search_history')

        result = []
        for review in cursor.stored_results():
            result.extend(review.fetchall())

        cursor.close()
        connection.close()

        if result:
            historial = [{"bus_fecha": row[0], "bus_termino": row[1]} for row in result]
            response = {"historial": historial}
        else:
            response = {"message": "No se encontró historial de busqueda."}

        return response

    except Exception as e:
        print(f"Error: {e}")
        return {"message": "Error en la solicitud."}