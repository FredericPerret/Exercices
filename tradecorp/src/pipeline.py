import sys

sys.path.append("/home/jovyan/src")

from reader import reader
from transformer import transformer
from writer import writer

def pipeline():
    dfs_raw = reader()
    dfs_cleaned, df_orders_enriched = transformer(dfs_raw)
    writer(df_orders_enriched)
