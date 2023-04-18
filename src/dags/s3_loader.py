import boto3
import vertica_python
from pathlib import Path
from logging import Logger

AWS_ACCESS_KEY_ID = "YCAJEWXOyY8Bmyk2eJL-hlt2K"
AWS_SECRET_ACCESS_KEY = "YCPs52ajb2jNXxOUsL4-pFDL1HnV2BCPd928_ZoA"

PATH_TO_SCRIPT = "/lessons/dags/sql/origin_to_staging.sql"

SQL_PARAMETERS = {
    "dialogs": "message_id, message_ts, message_from, message_to, message  ENFORCELENGTH, message_type",
    "groups": "id, admin_id, group_name, registration_dt, is_private",
    "users": "id, chat_name, registration_dt, country,age",
    "group_log": "group_id, user_id, user_id_from, event, datetime"
}

CONN_INFO = {'host': '51.250.75.20',
             'port': 5433,
             'user': 'KOSYAK1998YANDEXRU',
             'password': 'eTxHgF49CopW9TQ',
             'database': 'dwh',
             # autogenerated session label by default,
             'session_label': 'some_label',
             # default throw error on invalid UTF-8 results
             'unicode_error': 'strict',
             # SSL is disabled by default
             'ssl': False,
             # autocommit is off by default
             'autocommit': False,
             # using server-side prepared statements is disabled by default
             'use_prepared_statements': False,
             # connection timeout is not enabled by default
             # 5 seconds timeout for a socket operation (Establishing a TCP connection or read/write operation)
             'connection_timeout': 30}

def s3_load_file(bucket: str, key: str, log: Logger) -> None:
    session = boto3.session.Session()
    s3_client = session.client(
        service_name='s3',
        endpoint_url='https://storage.yandexcloud.net',
        aws_access_key_id=AWS_ACCESS_KEY_ID,
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY
    )
    log.info("S3 connection succses")
    s3_client.download_file(
        Bucket=bucket,
        Key=f'{key}.csv',
        Filename=f'/data/{key}.csv'
    )
    log.info(f"S3: {key} file download succses")
    script = Path(PATH_TO_SCRIPT).read_text()
    script = script.format(sql_key=key, sql_parameters=SQL_PARAMETERS[key])
    log.info("Prepared script to execute:")
    log.info(script)    
    with vertica_python.connect(**CONN_INFO) as connection:
        log.info("Vertica connection succses")
        cur = connection.cursor()
        cur.execute(script)
        log.info(f"Vertica: data upload into {key} table succses")
        connection.commit()