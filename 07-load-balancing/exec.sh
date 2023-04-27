#!/bin/bash 

PROFILE="labmfa"
STACK_NAME="fidelisalb"
TEMPLATE="alb-7-1-3.yaml"
PARAMETER="file://params.json"
KEY_NAME="fidelis"
REGION="us-east-1"

# deploy stack
aws cloudformation deploy --template-file $TEMPLATE \
     --stack-name $STACK_NAME --profile $PROFILE \
       --parameter-overrides $PARAMETER \
         --region $REGION

# create ec2 keypair 
# aws ec2 create-key-pair --key-name $KEY_NAME \
#   --query 'KeyMaterial' \
#     --region $REGION --profile $PROFILE \
#        --output text > fidelis.pem

# WHAT IS A SELF SIGNED CERTIFICATE 
# self-signed certificate is an SSL/TSL certificate not signed by a public or private certificate authority. 
# Instead, it is signed by the creator’s own personal or root CA certificate.
# Openssl is a handy utility to create self-signed certificates. You can use OpenSSL on all the 
# operating systems such as Windows, MAC, and Linux flavors.

# USER creates his own CA (rootCA and private key)

# generate server private key and create csr 
# mkdir openssl && cd openssl
# openssl req -x509 -nodes -days 365 \
#     -newkey rsa:2048 \
#      -keyout privateKey.key \
#       -out certificate.crt

# verify the key and cert generated 
# openssl rsa -in privateKey.key -check
# openssl x509 -in certificate.crt -text -noout
# import both private key and csr to acm 
# aws acm import-certificate --certificate file://certificate.crt \
#   --private-key file://privateKey.key \
#     --region $REGION \
#       --profile $PROFILE
