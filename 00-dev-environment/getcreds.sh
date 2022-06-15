#!/bin/bash
echo "Whats your 2FA token?"
read tokencode

default_acess_key_id=`cat ~/.aws/credentials | grep aws_access_key_id | head -n 1 | cut -d '=' -f 2 | tr -d '[:space:]'`
default_secret_acess_key=`cat ~/.aws/credentials | grep aws_secret_access_key | head -n 1 | cut -d '=' -f 2 | tr -d '[:space:]'`
default_mfa_serial=`cat ~/.aws/config | grep mfa_serial | head -n 1 | cut -d '=' -f 2 | tr -d '[:space:]'`

echo "Running: aws sts get-session-token --serial-number $default_mfa_serial --token-code $tokencode"
aws sts get-session-token --serial-number $default_mfa_serial --token-code $tokencode > /tmp/tokencode_data_dump.txt
cat /tmp/tokencode_data_dump.txt
