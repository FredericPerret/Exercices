import psycopg2
import os


conn = psycopg2.connect(
    host=os.getenv("POSTGRES_HOST"),
    port=os.getenv("POSTGRES_PORT"),
    dbname=os.getenv("POSTGRES_DB"),
    user=os.getenv("POSTGRES_USER"),
    password=os.getenv("POSTGRES_PASSWORD")
)
cur = conn.cursor()

cur.execute("CREATE TABLE IF NOT EXISTS goodproducts (id SERIAL PRIMARY KEY, name VARCHAR(255), price DECIMAL(10, 2), description TEXT)")
cur.execute("INSERT INTO goodproducts (name, price, description) VALUES ('Product 1', 20.01, 'good product')")
cur.execute("INSERT INTO goodproducts (name, price, description) VALUES ('Product 2', 30.01, 'better product')")
cur.execute("INSERT INTO goodproducts (name, price, description) VALUES ('Product 3', 40.01, 'best product')")

conn.commit()
conn.close()