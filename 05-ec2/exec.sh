#!/bin/bash 

PROFILE="labmfa"
STACK_NAME="fidelisEc2"
TEMPLATE="ec2-5-1-2.yaml"
PARAMETER="file://params.json"
KEY_NAME="fidelis"
REGION="us-east-1"

# deploy stack
aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --parameter-overrides $PARAMETER \
         --region $REGION