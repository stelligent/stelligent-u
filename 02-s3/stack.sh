#/bin/bash

#aws cloudformation validate-template --template-body file://unifying.yaml

#aws cloudformation create-stack --stack-name mattgbucketstack --template-body file://unifying.yaml

aws cloudformation update-stack --stack-name mattgbucketstack --template-body file://unifying.yaml

#aws cloudformation delete-stack --stack-name mattgbucketstack


#commands

