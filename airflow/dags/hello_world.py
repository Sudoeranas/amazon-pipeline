from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator


def say_hello():
    print("Hello, World! Stack is operational.")


with DAG(
    dag_id="hello_world",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["test"],
) as dag:
    PythonOperator(
        task_id="say_hello",
        python_callable=say_hello,
    )
