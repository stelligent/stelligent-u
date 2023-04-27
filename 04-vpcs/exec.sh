#!/bin/bash 

PROFILE="fidelis"
STACK_NAME="fidelisEc2"
TEMPLATE="vpc-4-1-4.yaml"
PARAMETER="file://params.json"
KEY_NAME="fidelis"
REGION="us-east-1"

# deploy stack
# aws cloudformation deploy --template-file $TEMPLATE \
#      --stack-name $STACK_NAME --profile $PROFILE \
#        --parameter-overrides $PARAMETER \
#          --region $REGION

# clean up
aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
      --profile $PROFILE \
        --region $REGION

# create ec2 keypair 
# aws ec2 create-key-pair --key-name $KEY_NAME \
#   --query 'KeyMaterial' \
#     --region $REGION --profile $PROFILE \
#        --output text > fidelis.pem 