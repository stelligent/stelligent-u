#!/usr/bin/env bash

aws cloudformation $1-stack --stack-name kpu-lab-04 --template-body file://vpc-peer.yaml --region us-east-1 | jq .
