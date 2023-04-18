from airflow import DAG
from airflow.operators.python import PythonOperator

from s3_loader import s3_load_file
from vertica import vertica_operator

import datetime
import logging


###POSTGRESQL settings###
#set postgresql connection from basehook
log = logging.getLogger(__name__)

with DAG(
    dag_id='s6_project_s3_to_staging_dag',
    start_date=datetime.datetime.today() - datetime.timedelta(minutes=20),
    catchup=False,
    dagrun_timeout=datetime.timedelta(minutes=10),
    tags=['sprint6', 's3_to_staging', 'project']
) as dag:

    load_staging = PythonOperator(
        task_id='load_staging',
        python_callable=s3_load_file,
        op_kwargs={
                'bucket': 'sprint6',
                'key': 'group_log',
                'log': log
            }
    )

    load_dds_hubs = PythonOperator(
        task_id='load_dds_hubs',
        python_callable=vertica_operator,
        op_kwargs={
                'path_to_script': '/lessons/dags/sql/staging_to_dds_hubs.sql',
                'log': log
            }
    )

    load_dds_links = PythonOperator(
        task_id='load_dds_links',
        python_callable=vertica_operator,
        op_kwargs={
                'path_to_script': '/lessons/dags/sql/staging_to_dds_links.sql',
                'log': log
            }
    )

    load_dds_satellites = PythonOperator(
        task_id='load_dds_satellites',
        python_callable=vertica_operator,
        op_kwargs={
                'path_to_script': '/lessons/dags/sql/staging_to_dds_sats.sql',
                'log': log
            }
    )
    
    load_staging >> load_dds_hubs >> load_dds_links >> load_dds_satellites




