#!/bin/bash

PROFILE="labmfa"
TEMPLATE="9-1-3.yaml"
STACK_NAME="fidelisApi"
BUCKET="stelligent-u-fidelisogunsanmi"
OUTPUT_FILE="template.packaged.yml"
REGION="us-east-1"

# validate stack 
# aws cloudformation validate-template \
#   --template-body file://$TEMPLATE \
#     --profile $PROFILE 
    
# deploy the stack 
# aws cloudformation deploy --template-file $TEMPLATE \
#      --stack-name $STACK_NAME --profile $PROFILE \
#        --capabilities CAPABILITY_NAMED_IAM \
#          --region $REGION

# aws apigateway test-invoke-method --rest-api-id **** \
#   --resource-id **** \
#     --http-method POST --path-with-query-string '/lambda' \
#        --profile $PROFILE \
#          --region $REGION

# aws cloudformation package 
# aws cloudformation package \
#   --template-file $TEMPLATE \
#     --s3-bucket $BUCKET \
#       --output-template-file $OUTPUT_FILE \
#           --profile $PROFILE \
#             --region $REGION

# aws cloudformation deploy 
aws cloudformation deploy \
  --template-file $OUTPUT_FILE \
    --stack-name $STACK_NAME \
      --region $REGION \
       --capabilities CAPABILITY_NAMED_IAM \
        --profile $PROFILE