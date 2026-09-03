from azure.storage.blob import BlobServiceClient
from os import getenv, walk, makedirs
from os.path import join, relpath, dirname
from shutil import rmtree

class ClientBlobAzure: # classe singleton pour gérer la connexion au service Azure Blob Storage
    _instance = None

    def __new__(cls):
        # If no instance exists, create one
        if cls._instance is None:
            cls._instance = super(ClientBlobAzure, cls).__new__(cls)
        return cls._instance

    def __init__(self):
        storage_account = getenv("AZURE_TENANT_ID")
        client_secret = getenv("AZURE_CLIENT_SECRET")
        account_url = f"https://{storage_account}.blob.core.windows.net"
        self.__blob_service_client = BlobServiceClient(account_url, credential=client_secret)
    
    def getFileFromBlob(self, container_name, blob_name, download_file_path):
        # téléchargement du fichier blob_name du conteneur container_name vers le fichier local download_file_path
        # le fichier local est écrasé s'il existe déjà
        blob_client = self.__blob_service_client.get_blob_client(container=container_name, blob=blob_name)
        with open(download_file_path, "wb") as download_file:
            download_file.write(blob_client.download_blob().readall())

    def getDirectoryFromBlob(self, container_name, blob_name, download_dir_path):
        # téléchargement de toute l'arborescence relative sous blob_name du conteneur container_name vers le répertoire local download_dir_path
        # l'éventuel ancien contenu de download_dir_path est supprimé avant le téléchargement
        container_client = self.__blob_service_client.get_container_client(container_name)
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
    
    def putFileToBlob(self, container_name, blob_name, upload_file_path):
        # upload du fichier local upload_file_path vers le blob blob_name du conteneur container_name
        # l'éventuel ancien contenu de blob_name est écrasé par l'upload
        blob_client = self.__blob_service_client.get_blob_client(container=container_name, blob=blob_name)
        with open(upload_file_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True)
    
    def putDirectoryToBlob(self, container_name, blob_name, upload_file_path):
        # upload de toute l'arborescence relative sous upload_file_path vers le répertoire blob_name du conteneur container_name
        # l'éventuel ancien contenu de blob_name est supprimé avant l'upload
        container_client = self.__blob_service_client.get_container_client(container_name)
        blob_list = container_client.list_blobs(name_starts_with=blob_name)
        for blob in blob_list:
            container_client.delete_blob(blob.name)
        # chargement du répertoire local vers le blob
        for root, _, files in walk(upload_file_path):
            for file_name in files:
                local_path = join(root, file_name)
                blob_path = relpath(local_path, start=upload_file_path).replace("\\", "/")
                blob_client = self.__blob_service_client.get_blob_client(container=container_name, blob=blob_name+'/'+blob_path)
                with open(local_path, "rb") as data:
                    blob_client.upload_blob(data, overwrite=True)

