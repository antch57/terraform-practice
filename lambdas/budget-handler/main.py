import json

def handler(event, context):
    # TODO implement
    print(json.dumps(event))
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
