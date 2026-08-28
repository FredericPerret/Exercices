FROM jupyter/pyspark-notebook:latest

USER root

RUN pip install --no-cache-dir \
    azure-identity \
    azure-keyvault-secrets

ADD https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.6/hadoop-azure-3.3.6.jar /opt/spark/jars/

USER jovyan