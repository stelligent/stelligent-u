import json
import configparser
import boto3
from pathlib import Path

# Setup connection to AWS
session = boto3.session.Session(profile_name='setup')
sts = session.client('sts')

# Get temporary credentials
code = input("Enter MFA code: ")
data = sts.get_session_token(SerialNumber='arn:aws:iam::324320755747:mfa/jakub.kwiatkowski.labs', TokenCode=code)

# Update credentials file
aws_creds_file = f'{str(Path.home())}/.aws/credentials'
config = configparser.ConfigParser()
config.read(aws_creds_file)
config['default']['region'] = 'us-east-1'
config['default']['aws_access_key_id'] = data['Credentials']['AccessKeyId']
config['default']['aws_secret_access_key'] = data['Credentials']['SecretAccessKey']
config['default']['aws_session_token'] = data['Credentials']['SessionToken']
with open(aws_creds_file, 'w') as cf:
    config.write(cf)
