import sys

sys.path.append("/home/jovyan/src")

from reader import reader
from transformer import transformer
from enrichment import enrichment
from writer import writer

def pipeline():
    dfs_raw = reader()
    dfs_cleaned, df_orders_enriched = transformer(dfs_raw)
    df_orders_enriched = enrichment(df_orders_enriched)
    writer(df_orders_enriched)
