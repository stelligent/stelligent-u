#!/bin/bash
# inputs needed - environment (ENV) and code (TOKEN)
echo $@
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -e|--env)
    ENV="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--token)
    TOKEN="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "${ENV}" = "lab" ]; then
  SERIAL='arn:aws:iam::324320755747:mfa/fidelis.ogunsanmi.labs'
fi

echo "Configuring $ENV with token $TOKEN"
CREDJSON="$(aws sts get-session-token --serial-number $SERIAL --profile $ENV --token-code $TOKEN)"

ACCESSKEY="$(echo $CREDJSON | jq '.Credentials.AccessKeyId' | sed 's/"//g')"
SECRETKEY="$(echo $CREDJSON | jq '.Credentials.SecretAccessKey' | sed 's/"//g')"
SESSIONTOKEN="$(echo $CREDJSON | jq '.Credentials.SessionToken' | sed 's/"//g')"
PROFILENAME="$ENV"

# echo "Profile $PROFILENAME AccessKey $ACCESSKEY SecretKey $SECRETKEY"
# echo "SessionToken $SESSIONTOKEN"

aws configure set aws_access_key_id $ACCESSKEY --profile $PROFILENAME
aws configure set aws_secret_access_key $SECRETKEY --profile $PROFILENAME
aws configure set aws_session_token $SESSIONTOKEN --profile $PROFILENAME

