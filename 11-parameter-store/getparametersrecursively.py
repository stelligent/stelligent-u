import boto3
ssm_client = boto3.client('ssm')
response = ssm_client.get_parameters_by_path(
    Path='/greyson.gundrum.labs/stelligent-u/lab11',
    Recursive=True,
    MaxResults=10
)
print (response)