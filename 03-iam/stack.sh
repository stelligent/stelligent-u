#/bin/bash

#aws cloudformation validate-template --template-body file://iam.yaml

#aws cloudformation create-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://iam.yaml

#aws cloudformation update-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://iam.yaml

#aws cloudformation delete-stack --stack-name mattgiamstack


#Bucket
#aws cloudformation validate-template --template-body file://bucket.yaml

#aws cloudformation create-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://bucket.yaml

aws cloudformation update-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://bucket.yaml

#aws cloudformation delete-stack --stack-name mattgiamstack

#assume role
#aws sts assume-role --role-arn "arn:aws:iam::324320755747:role/MattGIAMRole" --role-session-name mattgrolesession --duration-seconds 3600