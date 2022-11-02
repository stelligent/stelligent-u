import json
import boto3
import botocore

def lambda_handler(event, context):
    vision = event
    dynamodb = boto3.client('dynamodb')

    first_key = event.get('key1')
    second_key = event.get('key2')
    table_name = 'Module9'

    try:
        dynamodb.put_item(TableName=table_name, Item={'Key1':{'S':first_key},'Key2':{'S':second_key}})

        return {
            'statusCode': 200,
            'body': json.dumps(f'{first_key} and {second_key} {vision} written successfully to {table_name}')
            }
    except botocore.exceptions.ClientError as error:
        return {
            'statusCode': 500,
            'body': json.dumps(f"{error.response.get('Error').get('Code')}")
        }