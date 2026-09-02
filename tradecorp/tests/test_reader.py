import sys

sys.path.append("/home/jovyan/src")

from reader import reader

def test_reader():
    dfs_raw = reader()
    assert len(dfs_raw) == 8
    for file in ["categories", "products", "orders", "customers", "employees", "order_details", "suppliers", "shippers"]:
        assert file in dfs_raw
        assert dfs_raw[file].count() > 0
