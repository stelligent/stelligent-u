#/bin/bash

# OLD
#aws cloudformation create-stack --stack-name mattgstack --template-body file://cfn-bucket.yaml --parameters file://cfn-bucket-params.json
################

# bucket-user
#aws cloudformation create-stack --stack-name mattgstack --capabilities CAPABILITY_NAMED_IAM --template-body file://cfn-user.yaml
aws cloudformation update-stack --stack-name mattgstack --capabilities CAPABILITY_NAMED_IAM --template-body file://cfn-user.yaml

#aws cloudformation delete-stack --stack-name mattgstack

#aws cloudformation validate-template --template-body file://cfn-user.yaml

######
# import
#aws cloudformation validate-template --template-body file://import-stack.yaml

#aws cloudformation create-stack --stack-name mattgimportstack --capabilities CAPABILITY_NAMED_IAM --template-body file://import-stack.yaml

#aws cloudformation delete-stack --stack-name mattgimportstack