#!/bin/bash

PROFILE="labmfa"
LOG_GROUP_NAME="fidelis.ogunsanmi.c9logs"
LOG_STREAM_NAME="c9.training"
TEMPLATE="8-2-2.yaml"
STACK_NAME="fidelistestbucket"
REGION="us-east-1"

# deploy the stack 
aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --capabilities CAPABILITY_NAMED_IAM \
         --region $REGION

# create log group
# aws logs create-log-group --log-group-name $LOG_GROUP_NAME \
#   --profile $PROFILE \
#     --region $REGION 

# create log stream 
# aws logs create-log-stream --log-group-name $LOG_GROUP_NAME \
#   --log-stream-name $LOG_STREAM_NAME \
#    --profile $PROFILE \
#      --region $REGION 

# set retention policy 
# aws logs put-retention-policy --log-group-name $LOG_GROUP_NAME \
#   --retention-in-days 60 \
#    --profile $PROFILE \
#      --region $REGION 

# delete log stream
# aws logs delete-log-stream --log-group-name $LOG_GROUP_NAME \
#   --log-stream-name $LOG_STREAM_NAME \
#    --profile $PROFILE \
#      --region $REGION

# # delete log group
# aws logs delete-log-group --log-group-name $LOG_GROUP_NAME \
#    --profile $PROFILE \
#      --region $REGION 

  
    