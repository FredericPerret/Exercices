from datetime import datetime, timedelta
from pathlib import Path

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.operators.bash import BashOperator
from docker.types import Mount

PROJECT_DIR = r"//c/Users/Utilisateur/Documents/TP/tradecorp"

MOUNTS = [
    Mount(
        source=PROJECT_DIR + "/src",
        target="/home/jovyan/src",
        type="bind",
        read_only=True
    ),
    Mount(
        source=PROJECT_DIR + "/data",
        target="/home/jovyan/data",
        type="bind"
    ),
    Mount(
        source=PROJECT_DIR + "/.env",
        target="/home/jovyan/.env",
        type="bind",
        read_only=True
    )
]


with DAG(
    dag_id="tradecorp_etl_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule="0 6 * * *",
    catchup=False,
    default_args={
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
    },
    tags=["tradecorp", "etl", "spark"],
) as dag:
    fetch_exchange_rates = BashOperator(
        task_id="fetch_exchange_rates",
        bash_command="python3 /opt/airflow/src/fetch_exchange_rates.py",
    )
    reader = DockerOperator(
        task_id="reader",
        image="tradecorp-spark",
        docker_url="unix://var/run/docker.sock",
        network_mode="tradecorp_default",
        auto_remove=True,
        mount_tmp_dir=False,
        mounts=MOUNTS,
        command="spark-submit /home/jovyan/src/reader.py",
    )
    transformer = DockerOperator(
        task_id="transformer",
        image="tradecorp-spark",
        docker_url="unix://var/run/docker.sock",
        network_mode="tradecorp_default",
        auto_remove=True,
        mount_tmp_dir=False,
        mounts=MOUNTS,
        command="spark-submit /home/jovyan/src/transformer.py",
    )
    writer = DockerOperator(
        task_id="writer",
        image="tradecorp-spark",
        docker_url="unix://var/run/docker.sock",
        network_mode="tradecorp_default",
        auto_remove=True,
        mount_tmp_dir=False,
        mounts=MOUNTS,
        command="spark-submit /home/jovyan/src/writer.py",
    )

    fetch_exchange_rates >> reader >> transformer >> writer