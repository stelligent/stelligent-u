#/bin/bash

aws cloudformation update-stack --stack-name mattgstack --template-body file://cfn-bucket.yaml --parameters file://cfn-bucket-params.json