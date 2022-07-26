#!/bin/bash

PROFILE="labmfa"
TEMPLATE="10-1-2.yaml"
STACK_NAME="fideliskms"
KEY_ID="alias/KeyToFidelisHeart"
PLAIN_TEXT="fileb://secrets.json"
REGION="us-east-1"

# deploy the stack 
# aws cloudformation deploy --template-file $TEMPLATE \
#      --stack-name $STACK_NAME --profile $PROFILE \
#        --capabilities CAPABILITY_NAMED_IAM \
#          --region $REGION

# encrypting plaintext into ciphertext 
# aws kms encrypt --key-id $KEY_ID \
#   --plaintext $PLAIN_TEXT \
#     --output text --query CiphertextBlob \
#       --region $REGION --profile $PROFILE \
#         | base64 --decode > secrets.encrypted.json

# decrypting ciphertext into plaintext 
aws kms decrypt --ciphertext-blob fileb://secrets.encrypted.json \
    --output text --query Plaintext \
        | base64 --decode > secrets.decrypted.json


# upload file to s3 with sse enabled 
# aws s3 cp <file> s3://<bucket-name> --sse aws:kms --sse-kms-key-id "<key_id>"