import json
import os
import boto3
import uuid

# import requests


def lambda_handler(event, context):
    """Sample pure Lambda function

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format

        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    API Gateway Lambda Proxy Output Format: dict

        Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    """

    # try:
    #     ip = requests.get("http://checkip.amazonaws.com/")
    # except requests.RequestException as e:
    #     # Send some context about this error to Lambda Logs
    #     print(e)

    #     raise e
    # Create records
    table_name = os.getenv('TABLE_NAME')
    if os.getenv('AWS_SAM_LOCAL'):
        table = boto3.resource('dynamodb', endpoint_url="http://0.0.0.0:8000/").Table(table_name)
        # Inserting an item in a table
        table.put_item(Item={'id': str(uuid.uuid4())})
    else:
        region = os.getenv('AWS_REGION')
        table = boto3.resource('dynamodb', region_name=region).Table(table_name)


    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world",
            "TABLE_NAME": os.environ.get('TABLE_NAME'),
            # "location": ip.text.replace("\n", "")
        }),
    }
