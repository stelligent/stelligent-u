#/bin/bash

aws cloudformation create-stack --stack-name mattgstack --template-body file://cfn-bucket.yaml 