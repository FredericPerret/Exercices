from azure.storage.blob import BlobServiceClient
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat
from os import getenv

def clientBlobAzure():
    storage_account = getenv("AZURE_TENANT_ID")
    client_secret = getenv("AZURE_CLIENT_SECRET")
    account_url = f"https://{storage_account}.blob.core.windows.net"

    blob_service_client = BlobServiceClient(account_url, credential=client_secret)
    
    return blob_service_client

def getFileFromBlob(container_name, blob_name, download_file_path):
    blob_service_client = clientBlobAzure()
    # Get the blob client
    blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

    # Download the blob to a local file
    with open(download_file_path, "wb") as download_file:
        download_file.write(blob_client.download_blob().readall())

def clean_customers(df):
    # Remove duplicates based on 'customer_id'
    df_customers_clean = df.dropDuplicates(["customer_id"])   
    for c,type in df_customers_clean.dtypes:
        if type == 'string':
            df_customers_clean = df_customers_clean.withColumn(c,trim(col(c)))
            if c == "contact_name":
                df_customers_clean = df_customers_clean.withColumn(c,initcap(col(c)))
            elif c == "country":
                df_customers_clean = df_customers_clean.withColumn(c,upper(col(c)))   
    return df_customers_clean

def clean_orders(df):
    df_orders_clean = df.filter(col("shipped_date").isNotNull())
    df_orders_clean = df_orders_clean.withColumnRenamed("ship_via","shipper_id")
    df_orders_clean = df_orders_clean.withColumn("is_shipped",col("shipped_date").isNotNull())
    # les colonnes de date sont déjà au format date, donc pas besoin de les convertir
    # la colonne freight est déjà au format float, donc pas besoin de la convertir
    return df_orders_clean

def clean_order_details(df):
    # unit_price, quantity, discount sont déjà au bon format, donc pas besoin de les convertir
    df_order_details_clean = df.withColumnRenamed("unit_price","prix_unitaire").withColumnRenamed("quantity","quantite")
    df_order_details_clean = df_order_details_clean.withColumn("sous_total",round(col("prix_unitaire")*col("quantite")*(1-col("discount")),2))
    return df_order_details_clean

def clean_employees(df):
    df_employees_clean = df.select("employee_id", "first_name", "last_name", "title", "hire_date", "city", "country")\
                           .withColumn("full_name",concat(col("first_name"),lit(" "),col("last_name")))
    return df_employees_clean

def clean_products(df):
    # unit_price est déjà au bon format, donc pas besoin de le convertir
    df_products_clean = df.withColumn("en_stock",col("units_in_stock")>0)
    return df_products_clean

def build_enriched(dfs):
    df_products_categories = dfs["products"].join(dfs["categories"].select("category_id","category_name","description"), on="category_id", how="inner")
    df_orders_enriched = dfs["orders"]\
        .join(dfs["customers"].withColumnRenamed("company_name","customer_company_name")\
                              .withColumnRenamed("city","customer_city")\
                              .withColumnRenamed("country","customer_country")\
                              .withColumnRenamed("phone","customer_phone"), on="customer_id", how="inner")\
        .join(dfs["order_details"], on="order_id", how="inner")\
        .join(dfs["employees"].withColumnRenamed("city","employee_city")\
                              .withColumnRenamed("country","employee_country"), on="employee_id", how="inner")\
        .join(df_products_categories, on="product_id", how="inner")\
        .join(dfs["shippers"].withColumnRenamed("company_name","shipper_company_name")\
                             .withColumnRenamed("phone","shipper_phone"), on="shipper_id", how="inner")
    return df_orders_enriched