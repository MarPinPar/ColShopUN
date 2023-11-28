import mysql.connector
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from datetime import datetime, timedelta
from jose import JWTError, jwt

# MySQL configuration
mysql_config = {
    "host": "your_mysql_host",
    "user": "your_mysql_user",
    "password": "your_mysql_password",
    "database": "your_mysql_database",
}

# Passlib configuration for password handling
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# JWT configuration
SECRET_KEY = "your_secret_key"
ALGORITHM = "HS256"


# Establishes a connection to MySQL
conn = mysql.connector.connect(**mysql_config)


# Function to get a MySQL connection
def get_mysql_connection():
    return mysql.connector.connect(**mysql_config)


# Verifies if the plain text password matches the hashed password
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


# Gets the hash of a password
def get_password_hash(password):
    return pwd_context.hash(password)


# Gets user data by username from the database
def get_user(username: str):
    connection = get_mysql_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM USUARIO WHERE us_username = %s", (username,))
        user_data = cursor.fetchone()
    finally:
        cursor.close()
        connection.close()

    if user_data:
        return user_data


# Authenticates a user by verifying the username and password
def authenticate_user(username: str, password: str):
    connection = get_mysql_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM USUARIO WHERE us_username = %s", (username,))
        user_data = cursor.fetchone()
    finally:
        cursor.close()
        connection.close()

    if not user_data:
        return False

    hashed_password = user_data.get("us_contraseña", "")
    if not verify_password(password, hashed_password):
        return False

    return user_data


# Creates an access token with the provided data and an optional expiration time
def create_access_token(data: dict, expires_delta: timedelta or None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


# Gets the current user from the access token
async def get_current_user(token: str = Depends(oauth2_scheme)):
    credential_exception = HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                                         detail="Could not validate credentials",
                                         headers={"WWW-Authenticate": "Bearer"})
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credential_exception

        token_data = {"username": username}
    except JWTError:
        raise credential_exception

    user = get_user(username=token_data["username"])
    if user is None:
        raise credential_exception

    return user


# Gets the current active user from the current user
async def get_current_active_user(current_user: dict = Depends(get_current_user)):
    if current_user.get("disabled"):
        raise HTTPException(status_code=400, detail="Inactive user")

    return current_user
