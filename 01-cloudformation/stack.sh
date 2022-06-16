#/bin/bash

aws cloudformation create-stack --stack-name mattgstack --template-body file://cfn-bucket.yaml --parameters file://cfn-bucket-params.json

#aws cloudformation delete-stack --stack-name mattgstack

#aws cloudformation validate-template --template-body file://cfn-bucket.yaml