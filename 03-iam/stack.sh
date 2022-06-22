#/bin/bash

#aws cloudformation validate-template --template-body file://iam.yaml

#aws cloudformation create-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://iam.yaml

#aws cloudformation update-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://iam.yaml

#aws cloudformation delete-stack --stack-name mattgiamstack


#IAM2
#aws cloudformation validate-template --template-body file://iam2.yaml

aws cloudformation create-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://iam2.yaml

#aws cloudformation update-stack --stack-name mattgiamstack --capabilities CAPABILITY_NAMED_IAM --template-body file://iam2.yaml

#aws cloudformation delete-stack --stack-name mattgiamstack