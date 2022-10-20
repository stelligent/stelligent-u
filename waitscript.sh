#! /bin/bash
echo "Delete Command being issued"
aws cloudformation delete-stack --stack-name greysongundrum$CURRENT_LAB
echo "Delete command Issued"
aws cloudformation wait stack-delete-complete --stack-name greysongundrum$CURRENT_LAB 
echo "Deletion Complete"
echo "Issuing Creation Command"
aws cloudformation create-stack --stack-name greysongundrum$CURRENT_LAB --template-body "file://$PWD/$CURRENT_LAB.yaml" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --parameters file://$CURRENT_LAB.json
echo  "Create Command Sent"
echo "Waiting for Stack Creation to Complete"
aws cloudformation wait stack-create-complete --stack-name greysongundrum$CURRENT_LAB
echo "Create Complete"
