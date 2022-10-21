#To invoke the lambda function with the generate event
aws lambda invoke --function-name SAM-SQS-ProcessSqsFunction-9VpBgMnNIswj --cli-binary-format raw-in-base64-out --payload file://events/event.json response.json --profile labs
