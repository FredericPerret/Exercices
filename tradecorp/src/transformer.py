import sys

sys.path.append("/home/jovyan/src")

from utils import clean_customers, clean_orders, clean_order_details, clean_employees, clean_products, build_enriched


def transformer(dfs_raw):
    dfs_cleaned = {}
    dfs_cleaned["customers"] = clean_customers(dfs_raw["customers"])
    dfs_cleaned["orders"] = clean_orders(dfs_raw["orders"])
    dfs_cleaned["order_details"] = clean_order_details(dfs_raw["order_details"])
    dfs_cleaned["employees"] = clean_employees(dfs_raw["employees"])
    dfs_cleaned["products"] = clean_products(dfs_raw["products"])
    dfs_cleaned["categories"] = dfs_raw["categories"]
    dfs_cleaned["suppliers"] = dfs_raw["suppliers"]
    dfs_cleaned["shippers"] = dfs_raw["shippers"]

    df_orders_enriched = build_enriched(dfs_cleaned)

    return dfs_cleaned, df_orders_enriched
