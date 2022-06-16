#!/bin/bash

# Exercise 0.1.1
# Get Token from MFA and update credentials to a profile named for User name

usage() { echo "Usage: $0 [-t token of ARN device - Required] [-a <arn of MFA device] " 1>&2; exit 1; }

ARN='SECRET but can set in your local machine as a default'
TOKEN=''
while getopts a:t: arg
do
  case "${arg}" in
    a) ARN=${OPTARG};;
    t) TOKEN=${OPTARG};;
    *) usage ;; 
  esac
done

aws sts get-session-token --serial-number ${ARN} --token-code ${TOKEN} >> temp.json


# Should be optimized...
ACCESSKEYID=$(jq -r '.Credentials.AccessKeyId' temp.json)
SECRETACCESSKEY=$(jq -r '.Credentials.SecretAccessKey' temp.json)
SESSIONTOKEN=$(jq -r '.Credentials.SessionToken' temp.json)

cat << EOF >> /Users/tseng/.aws/credentials
[matthew.gable.labs]
aws_access_key_id = ${ACCESSKEYID}
aws_session_token = ${SESSIONTOKEN}
aws_secret_access_key = ${SECRETACCESSKEY}
region = us-east-1
output = json
EOF

# Should probably use the actual API
#aws configure import --csv file://tempprofile.csv

#cleanup
rm temp.json