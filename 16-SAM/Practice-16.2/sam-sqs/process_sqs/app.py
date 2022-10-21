import json

# import requests

def lambda_handler(event, context):
    for record in event['Records']:
      payload=record["body"]
      print(str(payload))
