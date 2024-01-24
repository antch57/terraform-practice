import json
import os

import boto3
from src.db import db_connection

# environment variables
aws_region = os.environ["AWS_REGION"]
rds_hostname = os.environ["RDS_HOSTNAME"]
secrets_manager_arn = os.environ["RDS_SECRET_ARN"]

# boto3 clients
secrets_manager_client = boto3.client("secretsmanager", region_name=aws_region)
s3_client = boto3.client("s3", region_name=aws_region)


def handler(event, context):
    db = None
    try:
        secret_value_response = secrets_manager_client.get_secret_value(
            SecretId=secrets_manager_arn
        )

        secret_value = json.loads(secret_value_response.get("SecretString"))

        print("Hello from Lambda! lets use this db module")
        db = db_connection.DBConnection(
            user=secret_value["username"],
            password=secret_value["password"],
            host=rds_hostname,
            database="",
        )

        db.connect()
        query = "SELECT 1;"
        rows = db.execute(query)

        for row in rows:
            print(row)

        print(json.dumps(event))
        return {"statusCode": 200, "body": "Hello from Lambda!"}
    except Exception as e:
        print(f"Error: {e}")
        return {"statusCode": 500, "body": "lambda failed!"}
    finally:
        if db is not None:
            db.close()
            print("db connection closed")
        else:
            print("no db connection to close")
