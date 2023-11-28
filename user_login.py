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
from main import *

SECRET_KEY = config('SECRET_KEY')
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 30
# MySQL database connection configuration
mysql_config = {
    "host": config('MYSQL_HOST'),
    "user": config('MYSQL_USER'),
    "password": config('MYSQL_PASSWORD'),
    "database": config('MYSQL_DATABASE'),
}

# Establish a MySQL connection
conn = mysql.connector.connect(**mysql_config)

def get_mysql_connection():
    return mysql.connector.connect(**mysql_config)


def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


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


def create_access_token(data: dict, expires_delta: timedelta or None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


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


async def get_current_active_user(current_user: dict = Depends(get_current_user)):
    if current_user.get("disabled"):
        raise HTTPException(status_code=400, detail="Inactive user")

    return current_user




