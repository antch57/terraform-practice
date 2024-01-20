import json
import os

import boto3
import mysql.connector

rds_hostname = os.environ["RDS_HOSTNAME"]
secrets_manager_client = boto3.client("secretsmanager")

# FIXME: should be passed in as an env var
secrets_manager_arn = ""


def handler(event, context):
    try:
        secret_value_response = secrets_manager_client.get_secret_value(
            SecretId=secrets_manager_arn
        )

        secret_value = json.loads(secret_value_response.get("SecretString"))

        print("Hello from Lambda! Lets try to connect to db")
        cnx = mysql.connector.connect(
            user=secret_value["username"],
            password=secret_value["password"],
            host=rds_hostname,
            port=3306,
            auth_plugin="mysql_native_password",
        )

        cursor = cnx.cursor()
        query = "SELECT 1;"
        cursor.execute(query)

        results = cursor.fetchall()
        for row in results:
            print(row)

        print(json.dumps(event))
        return {"statusCode": 200, "body": "Hello from Lambda!"}
    except Exception as e:
        print(f"Error: {e}")
        return {"statusCode": 500, "body": "lambda failed!"}

    finally:
        cnx.close()
        print("db connection closed")
