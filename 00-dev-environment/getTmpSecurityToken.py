#!/usr/bin/env python3

import sys 
import boto3
from utils.pyColors import MinStyle

st_profile='st_jh_labs'
mfa_token=sys.argv[1]
mfa_arn='arn:aws:iam::324320755747:mfa/john.hunter.labs'

print(f'\nMFA Token: {mfa_token}\n')

session = boto3.Session(profile_name=(st_profile))
st_profile_sts_client = session.client('sts')
caller_identity_response = st_profile_sts_client.get_caller_identity()

user_id=caller_identity_response.get("UserId")
account=caller_identity_response.get("Account")
arn=caller_identity_response.get("Arn")

print(f'UserId: {user_id}')
print(f'Account: {account}')
print(f'Arn: {arn}\n')

dur_seconds=43200 # 12 hour duration
session_token_response = st_profile_sts_client.get_session_token(
    DurationSeconds=(dur_seconds),
    SerialNumber=(mfa_arn),
    TokenCode=(mfa_token)
)

access_key_id=session_token_response.get("Credentials").get("AccessKeyId")
secret_access_key=session_token_response.get("Credentials").get("SecretAccessKey")
session_token=session_token_response.get("Credentials").get("SessionToken")

# print(f'\n')
print(f'New Temporary Session Credentials')
print(f'{MinStyle.LIGHTGREEN}{MinStyle.DIV_SINGLE_SHORT}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}AccessKeyId: {MinStyle.YELLOW}{access_key_id}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}SecretAccessKey: {MinStyle.YELLOW}{secret_access_key}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}SessionToken: {MinStyle.YELLOW}{session_token}{MinStyle.RESET}')
print()

