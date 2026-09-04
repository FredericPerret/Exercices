FROM jupyter/pyspark-notebook:latest

USER root

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD https://jdbc.postgresql.org/download/postgresql-42.7.8.jar /opt/spark/jars/

ADD https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.6/hadoop-azure-3.3.6.jar /opt/spark/jars/

USER jovyan