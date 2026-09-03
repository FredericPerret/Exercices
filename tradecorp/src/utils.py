from pyspark.sql.functions import trim, initcap, upper, col, round, lit, concat

# fonctions de nettoyage :

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

# fonction d'enrichissement pour le clean :

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