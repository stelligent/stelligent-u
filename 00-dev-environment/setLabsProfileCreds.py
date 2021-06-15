#!/usr/bin/env python3

import sys
import os 
import boto3
import configparser
from utils.pyColors import MinStyle

config=configparser.ConfigParser()

st_profile='st_jh_labs'
mfa_creds_profile='st_mfa_creds'
mfa_token=sys.argv[1]
MODFILE='/Users/John.Hunter/.aws/credentials'
mfa_arn='arn:aws:iam::324320755747:mfa/john.hunter.labs'

print(f'\nMFA Token: {mfa_token}\n')

st_session = boto3.Session(profile_name=(st_profile))
st_profile_sts_client = st_session.client('sts')
caller_identity_response = st_profile_sts_client.get_caller_identity()

print(f'{MinStyle.PINK}STS Caller Identity values{MinStyle.RESET}')
print(f'{MinStyle.LIGHTGREY}{MinStyle.DIV_SINGLE_SHORT}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}UserId: {MinStyle.WHITE}{caller_identity_response.get("UserId")}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}Account: {MinStyle.WHITE}{caller_identity_response.get("Account")}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}Arn: {MinStyle.WHITE}{caller_identity_response.get("Arn")}{MinStyle.RESET}')
print()


dur_seconds=43200 # 12 hour duration
session_token_response = st_profile_sts_client.get_session_token(
    DurationSeconds=(dur_seconds),
    SerialNumber=(mfa_arn),
    TokenCode=(mfa_token)
)
access_key_id=session_token_response.get("Credentials").get("AccessKeyId")
secret_access_key=session_token_response.get("Credentials").get("SecretAccessKey")
session_token=session_token_response.get("Credentials").get("SessionToken")

config.read(f'{MODFILE}')

# print(f'Profile Sections: {config.sections()}')
print(f'{MinStyle.PINK}Temporary Profile Credentials Original Values')
print(f'{MinStyle.LIGHTGREY}{MinStyle.DIV_SINGLE_SHORT}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}Profile: {MinStyle.YELLOW}{mfa_creds_profile}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}AccessKeyId: {MinStyle.YELLOW}{config.get(f"{mfa_creds_profile}", "aws_access_key_id")}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}SecretAccessKey: {MinStyle.YELLOW}{config.get(f"{mfa_creds_profile}", "aws_secret_access_key")}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}SessionToken: {MinStyle.YELLOW}{config.get(f"{mfa_creds_profile}", "aws_session_token")}{MinStyle.RESET}')

config.set(f'{mfa_creds_profile}', 'aws_access_key_id', f'{access_key_id}')
config.set(f'{mfa_creds_profile}', 'aws_secret_access_key', f'{secret_access_key}')
config.set(f'{mfa_creds_profile}', 'aws_session_token', f'{session_token}')

with open ((MODFILE), 'w') as configfile:
    config.write(configfile)

print()
print(f'{MinStyle.PINK}New Temporary Session Token Credentials')
print(f'{MinStyle.LIGHTGREY}{MinStyle.DIV_SINGLE_SHORT}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}Modified Profile: {MinStyle.YELLOW}{mfa_creds_profile}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}AccessKeyId: {MinStyle.YELLOW}{access_key_id}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}SecretAccessKey: {MinStyle.YELLOW}{secret_access_key}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}SessionToken: {MinStyle.YELLOW}{session_token}{MinStyle.RESET}')
print()


# print(f'{MinStyle.LIGHTCYAN}AWS_PROFILE= {MinStyle.YELLOW}{os.getenv("AWS_PROFILE")}{MinStyle.RESET}\n')
# os.environ['AWS_PROFLE']='st_mfa_creds'
# print(f'{MinStyle.LIGHTCYAN}AWS_PROFILE= {MinStyle.YELLOW}{os.getenv("AWS_PROFILE")}{MinStyle.RESET}\n')

iam_session = boto3.Session(profile_name=(mfa_creds_profile))
iam_client = iam_session.client('iam')

get_user_response=iam_client.get_user()

print(f'{MinStyle.PINK}IAM get-user Response using tmp session credentials{MinStyle.RESET}')
print(f'{MinStyle.LIGHTGREY}{MinStyle.DIV_SINGLE_SHORT}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}UserName: {MinStyle.WHITE}{get_user_response.get("User").get("UserName")}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}UserId: {MinStyle.WHITE}{get_user_response.get("User").get("UserId")}{MinStyle.RESET}')
print(f'{MinStyle.LIGHTCYAN}Arn: {MinStyle.WHITE}{get_user_response.get("User").get("Arn")}{MinStyle.RESET}')
print()

