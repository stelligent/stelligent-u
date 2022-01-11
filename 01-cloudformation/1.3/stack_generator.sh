#!/usr/bin/env bash

## Because I want my 'aws' alias to docker:
## ❯ which aws
## aws: aliased to docker run --rm -it -v $HOME/.aws:/root/.aws -v $HOME/codehome/aws/docker:/aws amazon/aws-cli:2.2.11
## ... and I had to specifically source this
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
shopt -s expand_aliases

STACK_NAME="${1:-ksDefaultStackSlug}"

## expecting to see my parameters beside me
parameters_file="$(dirname "${BASH_SOURCE[@]}")/deployment-regions.json"

[[ ! -f "$parameters_file" ]] && echo "ERROR: $parameters_file not found" >&2 && exit 1

declare -a regions=($(jq -r '.regions[]' $parameters_file))

[[ "${#regions[@]}" -eq 0 ]] && echo "ERROR: Unable to find any regions defined in $parameters_file" >&2 && exit 1

echo "--> $(date) :: Creating $STACK_NAME in the following regions: $(echo "${regions[@]}" | sed 's/ /, /g')"

ERRORS=0
for r in ${regions[@]}
do
    echo " --> Creating stack: $STACK_NAME in region: $r ..."
    aws cloudformation create-stack \
        --stack-name $STACK_NAME \
        --region $r \
        --template-body file:///aws/1.3/s3-buckets.yaml \
        --parameters ParameterKey=FriendlyBucketName,ParameterValue=kshenk-script-override

    [[ "$?" -ne 0 ]] && {
        echo " --> ERROR: Failed to create $STACK_NAME in $r"
        ((ERRORS++))
    }
done

exit $ERRORS
