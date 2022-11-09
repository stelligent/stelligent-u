import boto3
ssm_client = boto3.client('ssm')
response = ssm_client.get_parameter(Name='/greyson.gundrum.labs/stelligent-u/lab11/steven-stevenson')
print (response)