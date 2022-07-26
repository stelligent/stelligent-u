#!/bin/bash 

PROFILE="labmfa"
BUCKET_NAME="stelligent-u-fidelisogunsanmi"
STACK_NAME="fidelistestlab"
TEMPLATE="s3.yaml"
REGION="us-west-2"
PARAMETERS="file://name.json"

# Lab 2.1.1: Create a Bucket
# aws s3 mb s3://$BUCKET_NAME \
#       --profile $PROFILE \
#         --region $REGION 

# List contents of the bucket 
# aws s3 ls s3://$BUCKET_NAME \
#       --profile $PROFILE 
   
# Lab 2.1.2: Upload Objects to a Bucket
# aws s3 cp data/index.html s3://$BUCKET_NAME/index.html \
#       --profile $PROFILE

# aws s3 sync data s3://$BUCKET_NAME/data \
#    --profile $PROFILE \
#       --exclude "private-file"

# Nobody else can see the bucket at this point. 

# The sync command is what you want 
# as it is designed to handle keeping two folders in sync while copying the minimum amount of data. 
# Sync should result in less data being pushed into S3 bucket so that should have a less cost overall.

# Lab 2.1.3: Exclude Private Objects When Uploading to a Bucket

# aws s3 cp data s3://$BUCKET_NAME \
#    --recursive --exclude "private-file" \
#      --profile $PROFILE

# Lab 2.1.4: Clean Up

# aws s3 rm s3://$BUCKET_NAME/data/private-file \
#    --recursive \
#      --profile $PROFILE

# aws s3 rb s3://$BUCKET_NAME \
#   --profile $PROFILE \
#     --force 

# Lab 2.2.1: Recreate the Bucket with Public Data

# aws s3 sync data s3://$BUCKET_NAME/data \
#    --profile $PROFILE \
# #       --acl public-read 

# Lab 2.2.2: Use the CLI to Restrict Access to Private Data
# aws s3 sync data s3://$BUCKET_NAME/data \
#    --profile $PROFILE \
#       --acl private 

# Lab 2.3.1: Set up for Versioning
# aws cloudformation deploy --template-file $TEMPLATE \
#      --stack-name $STACK_NAME --profile $PROFILE \
#          --region $REGION

# # After syncing the modified local files, we have different versions of the files since versioning is enabled 

# Lab 2.3.2: Object Versions

# After deleting the object i can still fetch the deleted object cos of versioning 

# To delete versioned objects permanently, you must use DELETE Object versionId.

# Lab 2.3.3: Tagging S3 Resources

# Updated the CFN template - "s3.yaml" to add tags to the bucket 

# With Amazon S3 tagging, if you want to add or replace a tag in a tag set (all the tags associated with an object or bucket), 
# you must download all the tags, modify the tags, and then replace all the tags at once. 

# Lab 2.3.4: Object Lifecycles

# The CFN template - "s3.yaml" has all the details to create the lifecycles 

