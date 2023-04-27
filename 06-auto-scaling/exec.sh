#!/bin/bash 

PROFILE="labmfa"
STACK_NAME="fidelisvPC"
TEMPLATE="vpc.yaml"
PARAMETER="file://params.json"
KEY_NAME="fidelis"
REGION="us-east-1"

# deploy stack
aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --parameter-overrides $PARAMETER \
         --region $REGION

# create ec2 keypair 
# aws ec2 create-key-pair --key-name $KEY_NAME \
#   --query 'KeyMaterial' \
#     --region $REGION --profile $PROFILE \
#        --output text > fidelis.pem

