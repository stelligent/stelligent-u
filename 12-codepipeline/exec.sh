#!/bin/sh

PROFILE="labmfa"
STACK_NAME="github-pipeline-fidelis"
TEMPLATE="12-1-1.yaml"
REGION="us-east-1"

# deploy stack
aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
      --capabilities CAPABILITY_NAMED_IAM \
         --region $REGION



