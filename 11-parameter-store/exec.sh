#!/bin/bash 

STACK_NAME="fideliSssm"
TEMPLATE="11-1-3.yaml"
PROFILE="labmfa"
PARAMETER="file://params.json"
REGION="us-east-1"


aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --parameter-overrides $PARAMETER \
         --region $REGION