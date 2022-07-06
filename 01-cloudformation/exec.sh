#!/bin/bash 

STACK_NAME="fidelis-test-new-lab"
TEMPLATE="s3-import.yaml"
PROFILE="labmfa"
REGION="us-east-1"

aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --capabilities CAPABILITY_NAMED_IAM \
         --region $REGION

# aws cloudformation list-exports \
#    --profile $PROFILE \
#      --region $REGION