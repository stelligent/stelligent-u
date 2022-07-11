#!/bin/bash 

PROFILE="labmfa"
STACK_NAME="fidelisiam"
TEMPLATE="iam-3-3-1.yaml"
REGION="us-east-1"
POLICY_NAME="fidelisUsersts"
POLICY_DOC="file://user-policy.json"
POLICY_ARN="arn:aws:iam::324320755747:policy/fidelisUsersts"
USERNAME="fidelis.ogunsanmi.labs"
ROLE_ARN="arn:aws:iam::324320755747:role/fidelisRole"


# Lab 3.1.1: IAM Role
# aws cloudformation deploy --template-file $TEMPLATE \
#      --stack-name $STACK_NAME --profile $PROFILE \
#        --capabilities CAPABILITY_NAMED_IAM \
#          --region $REGION

# aws iam list-roles \
#   --profile $PROFILE 
   
# aws iam list-roles --profile $PROFILE  \
#      | jq -r '.Roles[] | select(.RoleName|match("fidelisRole")) | .Arn' 

# Lab 3.1.6: Clean Up

# aws cloudformation delete-stack --stack-name $STACK_NAME \
#      --profile $PROFILE \

# Create the iam policy that gives access to assume role 
# aws iam create-policy --policy-name $POLICY_NAME \
#     --policy-document $POLICY_DOC \
#        --profile $PROFILE 

# attach the policy to the fidelis.ogunsanmi.labs user 
# aws iam attach-user-policy --user-name $USERNAME \
#   --policy-arn $POLICY_ARN \
#     --profile $PROFILE 

# assume the Role 
# aws sts assume-role --role-arn $ROLE_ARN \
#    --role-session-name AWSCLI \


    
      