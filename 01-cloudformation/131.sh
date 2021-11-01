jq -r ".regions[]" regions.json | while read i; do
    echo "-->" $i
    aws cloudformation create-stack \
       --stack-name ph-lab131-stack \
       --template-body file://cfn-m131.yml \
       --capabilities CAPABILITY_NAMED_IAM \
       --parameters file://parameters-m131.json \
       --region $i 
done