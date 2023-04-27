# Documentation for the cloudformation module

This holds all the informations about scripts and templates i created in this module

## Lab 1.1.1

- s3_1.yaml template will create a simple s3 bucket.
- I have used the aws cli tool to deploy the stack
  - aws cloudformation deploy --template-file s3.yaml --stack-name s3-bucket-create
- If we notice, the bucket has been named: s3-bucket-create-s3bucket-15s1dsy5yhdfa

## Lab 1.1.2: Stack Parameters

- s3-params.yaml template will create the bucket and name it using the parameter file name.json
- command used to update the stack is:
  - aws cloudformation deploy --template-file s3-params.yaml --stack-name s3-bucket-create --profile labmfa --parameter-overrides file://name.json

## Lab 1.1.3: Pseudo-Parameters

- s3-pseudo.yaml has the template
- This will prefix the bucketname with the aws account id

### Scripts

- exec.sh: This script does the cli kick of the deployment.

## Lab 1.2.1: Cross-Referencing Resources within a Template

- s3-iam.yaml creates the stack

## Lab 1.2.2: Exposing Resource Details via Exports

- updated s3-iam.yaml to update the stack
- exec.sh has the commands used to list all stack exports

## Lab 1.2.3: Importing another Stack's Exports

- s3-import.yaml creates the stack
