#!/usr/bin/env bash

aws cloudformation $1-stack --stack-name kpu-lab-04-peer --template-body file://vpc-peering.yaml | jq .
