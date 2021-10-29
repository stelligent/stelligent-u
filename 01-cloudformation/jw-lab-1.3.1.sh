#!/bin/bash

# cat us-regions.json| jq ".regions"    
# [
#   "us-east-1",
#   "us-east-2",
#   "us-west-1",
#   "us-west-2"
# ]

# cat us-regions.json| jq -c ".regions"
#  ["us-east-1","us-east-2","us-west-1","us-west-2"]

# Iterate over each region in us-region.json
jq -r ".regions[]" us-regions.json | while read i; do
    echo "-->" $i
    aws cloudformation create-stack \
       --stack-name jw-lab131-stack \
       --template-body file://jw-lab-1.3.1.yml \
       --capabilities CAPABILITY_NAMED_IAM \
       --parameters file://jw-lab-1.3.1.json \
       --region $i #&
done