from azure.storage.blob import BlobServiceClient
from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat
from os import getenv, walk, makedirs
from os.path import join, relpath, dirname
from shutil import rmtree

class ClientBlobAzure:
    def __init__(self):
        storage_account = getenv("AZURE_TENANT_ID")
        client_secret = getenv("AZURE_CLIENT_SECRET")
        account_url = f"https://{storage_account}.blob.core.windows.net"
        self.blob_service_client = BlobServiceClient(account_url, credential=client_secret)
    
    def getFileFromBlob(self, container_name, blob_name, download_file_path):
        # téléchargement du fichier blob_name du conteneur container_name vers le fichier local download_file_path
        # le fichier local est écrasé s'il existe déjà
        blob_client = self.blob_service_client.get_blob_client(container=container_name, blob=blob_name)
        with open(download_file_path, "wb") as download_file:
            download_file.write(blob_client.download_blob().readall())

    def getDirectoryFromBlob(self, container_name, blob_name, download_dir_path):
        # téléchargement de toute l'arborescence relative sous blob_name du conteneur container_name vers le répertoire local download_dir_path
        # l'éventuel ancien contenu de download_dir_path est supprimé avant le téléchargement
        container_client = self.blob_service_client.get_container_client(container_name)
        rmtree(download_dir_path, ignore_errors=True)
        makedirs(download_dir_path, exist_ok=True)
        blob_list = container_client.list_blobs(name_starts_with=blob_name)
        for blob in blob_list:
            relative_path = blob.name[len(blob_name):].lstrip('/')
            local_file_path = join(download_dir_path, relative_path)
            local_dir = dirname(local_file_path)
            makedirs(local_dir, exist_ok=True)
            with open(local_file_path, "wb") as file:
                download_stream = container_client.download_blob(blob.name)
                file.write(download_stream.readall())
    
    def putDirectoryToBlob(self, container_name, blob_name, upload_file_path):
        # upload de toute l'arborescence relative sous upload_file_path vers le répertoire blob_name du conteneur container_name
        # l'éventuel ancien contenu de blob_name est supprimé avant l'upload
        container_client = self.blob_service_client.get_container_client(container_name)
        blob_list = container_client.list_blobs(name_starts_with=blob_name)
        for blob in blob_list:
            container_client.delete_blob(blob.name)
        # chargement du répertoire local vers le blob
        for root, _, files in walk(upload_file_path):
            for file_name in files:
                local_path = join(root, file_name)
                blob_path = relpath(local_path, start=upload_file_path).replace("\\", "/")
                blob_client = self.blob_service_client.get_blob_client(container=container_name, blob=blob_name+'/'+blob_path)
                with open(local_path, "rb") as data:
                    blob_client.upload_blob(data, overwrite=True)


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
    df_products_categories = dfs["products"].join(dfs["categories"].select("category_id","category_name"), on="category_id", how="inner")
    df_orders_enriched = dfs["orders"]\
        .join(dfs["customers"].withColumnRenamed("company_name","customer_name")\
                              .withColumnRenamed("city","customer_city")\
                              .withColumnRenamed("country","customer_country")\
                              .withColumnRenamed("phone","customer_phone"), on="customer_id", how="inner")\
        .join(dfs["order_details"], on="order_id", how="inner")\
        .join(dfs["employees"].withColumnRenamed("city","employee_city")\
                              .withColumnRenamed("country","employee_country"), on="employee_id", how="inner")\
        .join(df_products_categories, on="product_id", how="inner")\
        .join(dfs["shippers"].withColumnRenamed("company_name","shipper_name")\
                             .withColumnRenamed("phone","shipper_phone"), on="shipper_id", how="inner")\
        .select("order_id","customer_id","employee_id","product_id","order_date","required_date","shipped_date","freight","is_shipped","prix_unitaire","quantite",\
                "discount","sous_total","customer_name","customer_country","customer_city","product_name","category_name","en_stock","full_name","shipper_name")
    return df_orders_enriched