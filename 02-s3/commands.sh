#/bin/bash

# This is a document that shows work when there are not any mandatory file changes

exit

2.1.1
aws s3api create-bucket --region us-west-2 --bucket stelligent-u-matthew.gable.labs --create-bucket-configuration LocationConstraint=us-west-2
aws s3api list-objects --bucket stelligent-u-matthew.gable.labs

2.1.2
aws s3 cp ./data s3://stelligent-u-matthew.gable.labs/data --recursive

2.1.3
aws s3 sync ./data s3://stelligent-u-matthew.gable.labs/data --exclude privatefile.txt

2.2.1
aws s3api create-bucket --region us-west-2 --bucket stelligent-u-matthew.gable.labs --create-bucket-configuration LocationConstraint=us-west-2

