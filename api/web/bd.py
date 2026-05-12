# bd.py
import os
import pymysql
##from dotenv import load_dotenv

##load_dotenv()

def obtener_conexion():
    return pymysql.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        port=int(os.getenv("DB_PORT", 3306)),
        database=os.getenv("DB_NAME"),
        cursorclass=pymysql.cursors.DictCursor
    )
