#!/bin/bash 

STACK_NAME="s3-bucket-create"
TEMPLATE="s3-cond.yaml"
PROFILE="labmfa"
REGION="us-east-2"

aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --parameter-overrides file://name.json \
         --region $REGION