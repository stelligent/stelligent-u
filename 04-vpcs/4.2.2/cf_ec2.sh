#!/usr/bin/env bash

aws cloudformation $1-stack --stack-name kpu-lab-04-ec2 --template-body file://ec2.yaml --region us-east-1 | jq .
