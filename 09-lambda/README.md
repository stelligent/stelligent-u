# Topic 9: Lambda

<!-- TOC -->

- [Topic 9: Lambda](#topic-9-lambda)
  - [Conventions](#conventions)
  - [Lesson 9.1: Lambda is a fully-managed compute resource](#lesson-91-lambda-is-a-fully-managed-compute-resource)
    - [Principle 9.1](#principle-91)
    - [Practice 9.1](#practice-91)
      - [Lab 9.1.1: Simple Lambda function](#lab-911-simple-lambda-function)
      - [Lab 9.1.2: Lambda behind API Gateway](#lab-912-lambda-behind-api-gateway)
      - [Lab 9.1.3: Lambda & CloudFormation with awscli](#lab-913-lambda--cloudformation-with-awscli)
    - [Retrospective 9.1](#retrospective-91)
      - [Task](#task)
  - [Lesson 9.2: Lambda and other AWS resources](#lesson-92-lambda-and-other-aws-resources)
    - [Principle 9.2](#principle-92)
    - [Practice 9.2](#practice-92)
      - [Lab 9.2.1: Lambda with DynamoDB](#lab-921-lambda-with-dynamodb)
      - [Lab 9.2.2: Lambda via CloudWatch Rules](#lab-922-lambda-via-cloudwatch-rules)
      - [Lab 9.2.3: Query data with Lambda and API Gateway](#lab-923-query-data-with-lambda-and-api-gateway)
    - [Retrospective 9.2](#retrospective-92)
      - [Question](#question)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Conventions

- DO use the [AWS Lambda documentation](https://aws.amazon.com/documentation/lambda/),
  [DynamoDB documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-dynamodb-table.html),
  and [ApiGateway documentation.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-method.html)

- DO continuously commit all your templates and code to the topic
  folder in your GitHub repo.

## Lesson 9.1: Lambda is a fully-managed compute resource

### Principle 9.1

*As a fully managed compute resource, Lambda can reduce all the time and
effort to configure and maintain virtual servers.*

Lambda gives you a fully-managed compute resource running in AWS that
allows you to run your code on demand with very little configuration
needed and no maintenance required. AWS also provides robust testing
tools via Cloud9, and methods of packaging and deploying your code
easily. Lambda can be paired with API gateway to quickly create
microservices.

API Gateway is a fully managed service that makes it easy to create,
publish, maintain, monitor, and secure APIs at any scale. You can create
an API that acts as a "front door" for applications to access data or
functionality from your back-end services, such as workloads running on
EC2, code running on AWS Lambda, or any web application.

### Practice 9.1

#### Lab 9.1.1: Simple Lambda function

Create and test a simple AWS Lambda function using the Lambda console.

- Use the wizard to create a new Lambda using your choice of language.

- Update the lambda to return "Hello AWS!" and use the "Test" tool to
  run a test.

- Review the options you have for testing and running Lambdas.

- When you're done, delete the Lambda.

#### Lab 9.1.2: Lambda behind API Gateway

Using API gateway to run a Lambda function.

- Use CloudFormation to create the same lambda as you did in lab 1.
  Use the in-line code feature to write the same "Hello AWS!"
  function.

- Add an AWS API gateway to your template. Configure the gateway so
  that it will call the lambda function. You will need to implement:

  - `AWS::ApiGateway::Method`
  - `AWS::ApiGateway::RestApi`
  - `AWS::ApiGateway::Deployment`
  - Lambda execution role (`AWS::IAM::Role`) with an AssumeRole policy
  - Appropriate Lambda invoke permissions (`AWS::Lambda::Permission`)

- Use the AWS CLI to call the API gateway which will call your Lambda
  function.

  greyson.gundrum@MACUSSTG2541764 git % aws apigateway test-invoke-method --rest-api-id 9aikgvuxhi --resource-id e6ri9s --http-method POST
{
    "status": 200,
    "body": "{\"message\": \"Hello AWS!\"}",
    "headers": {
        "X-Amzn-Trace-Id": "Root=1-6361fc18-be0ba16ea615611d98ab8f9a;Sampled=0"
    },
    "multiValueHeaders": {
        "X-Amzn-Trace-Id": [
            "Root=1-6361fc18-be0ba16ea615611d98ab8f9a;Sampled=0"
        ]
    },
    "log": "Execution log for request 467a2d02-6884-4265-b33f-336cba1aa00f\nWed Nov 02 05:11:52 UTC 2022 : Starting execution for request: 467a2d02-6884-4265-b33f-336cba1aa00f\nWed Nov 02 05:11:52 UTC 2022 : HTTP Method: POST, Resource Path: /helloworld\nWed Nov 02 05:11:52 UTC 2022 : Method request path: {}\nWed Nov 02 05:11:52 UTC 2022 : Method r:

- Lambdas can take a payload like JSON as input. Rewrite the function
  to take a JSON payload and simply return the payload, or an item
  from the payload.

greyson.gundrum@MACUSSTG2541764 09-lambda % curl -v -X POST \
  'https://qeaqswth7g.execute-api.us-west-2.amazonaws.com/test/helloworld?name=John&city=Seattle' \
  -H 'content-type: application/json' \
  -H 'day: Thursday' \
  -d '{ "time": "evening" }'
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 35.166.153.132:443...
* Connected to qeaqswth7g.execute-api.us-west-2.amazonaws.com (35.166.153.132) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (OUT), TLS handshake, Client hello (1):
* (304) (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=*.execute-api.us-west-2.amazonaws.com
*  start date: Jul  2 00:00:00 2022 GMT
*  expire date: Jul 31 23:59:59 2023 GMT
*  subjectAltName: host "qeaqswth7g.execute-api.us-west-2.amazonaws.com" matched cert's "*.execute-api.us-west-2.amazonaws.com"
*  issuer: C=US; O=Amazon; OU=Server CA 1B; CN=Amazon
*  SSL certificate verify ok.
* Using HTTP2, server supports multiplexing
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7fdada810a00)
> POST /test/helloworld?name=John&city=Seattle HTTP/2
> Host: qeaqswth7g.execute-api.us-west-2.amazonaws.com
> user-agent: curl/7.79.1
> accept: */*
> content-type: application/json
> day: Thursday
> content-length: 21
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
* We are completely uploaded and fine
< HTTP/2 200 
< date: Wed, 02 Nov 2022 05:33:26 GMT
< content-type: application/json
< content-length: 1763
< x-amzn-requestid: a74a823e-8385-4f47-aa49-be10753ad073
< x-amz-apigw-id: a9UeEEv_vHcFolw=
< x-custom-header: my custom header value
< x-amzn-trace-id: Root=1-63620126-7889a7d1251c578001426315;Sampled=0
< 
* Connection #0 to host qeaqswth7g.execute-api.us-west-2.amazonaws.com left intact
{"message":"Good evening, John of Seattle. Happy Thursday!","input":{"resource":"/helloworld","path":"/helloworld","httpMethod":"POST","headers":{"accept":"*/*","content-type":"application/json","day":"Thursday","Host":"qeaqswth7g.execute-api.us-west-2.amazonaws.com","User-Agent":"curl/7.79.1","X-Amzn-Trace-Id":"Root=1-63620126-7889a7d1251c578001426315","X-Forwarded-For":"163.116.139.118","X-Forwarded-Port":"443","X-Forwarded-Proto":"https"},"multiValueHeaders":{"accept":["*/*"],"content-type":["application/json"],"day":["Thursday"],"Host":["qeaqswth7g.execute-api.us-west-2.amazonaws.com"],"User-Agent":["curl/7.79.1"],"X-Amzn-Trace-Id":["Root=1-63620126-7889a7d1251c578001426315"],"X-Forwarded-For":["163.116.139.118"],"X-Forwarded-Port":["443"],"X-Forwarded-Proto":["https"]},"queryStringParameters":{"city":"Seattle","name":"John"},"multiValueQueryStringParameters":{"city":["Seattle"],"name":["John"]},"pathParameters":null,"stageVariables":null,"requestContext":{"resourceId":"jbdryu","resourcePath":"/helloworld","httpMethod":"POST","extendedRequestId":"a9UeEEv_vHcFolw=","requestTime":"02/Nov/2022:05:33:26 +0000","path":"/test/helloworld","accountId":"324320755747","protocol":"HTTP/1.1","stage":"test","domainPrefix":"qeaqswth7g","requestTimeEpoch":1667367206641,"requestId":"a74a823e-8385-4f47-aa49-be10753ad073","identity":{"cognitoIdentityPoolId":null,"accountId":null,"cognitoIdentityId":null,"caller":null,"sourceIp":"163.116.139.118","principalOrgId":null,"accessKey":null,"cognitoAuthenticationType":null,"cognitoAuthenticationProvider":null,"userArn":null,"userAgent":"curl/7.79.1","user":null},"domainName":"qeaqswth7g.execute-api.us-west-2.amazonaws.com","apiId":"qeaqswth7g"},"body":"{ \"time\": \"evening\" }","isBase64Encoded":false}}%     

#### Lab 9.1.3: Lambda & CloudFormation with awscli

Use the AWS CLI to create Lambda functions:

- Using the template you created in lab 2, move the in-line code to a
  separate file and update the Lambda resource to reference the
  handler.

- Use the "aws cloudformation package" and "\... deploy" commands to
  create the CloudFormation stack. Note: The "package" command will
  need an S3 bucket to temporarily store the deployment package.

- Use the API gateway to make a test call to the lambda to confirm
  it's working.

aws cloudformation package --template-file ./913.yaml --s3-bucket greysongundrumlambdabucket --output-template-file package-template.yaml


Successfully packaged artifacts and wrote output template to file package-template.yaml.
Execute the following command to deploy the packaged template

greyson.gundrum@MACUSSTG2541764 09-lambda % aws cloudformation deploy --template-file /Users/greyson.gundrum/git/stelligent-u/09-lambda/package-template.yaml --stack-name testingcfpackagestack --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

Waiting for changeset to be created..
Waiting for stack create/update to complete
Successfully created/updated stack - testingcfpackagestack
greyson.gundrum@MACUSSTG2541764 09-lambda % curl -v -X POST \  'https://j05t06m4a0.execute-api.us-west-2.amazonaws.com/test/helloworld?name=John&city=Seattle' \    
  -H 'content-type: application/json' \
  -H 'day: Thursday' \
  -d '{ "time": "evening" }'
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 52.27.145.6:443...
* Connected to j05t06m4a0.execute-api.us-west-2.amazonaws.com (52.27.145.6) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (OUT), TLS handshake, Client hello (1):
* (304) (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=*.execute-api.us-west-2.amazonaws.com
*  start date: Jul  2 00:00:00 2022 GMT
*  expire date: Jul 31 23:59:59 2023 GMT
*  subjectAltName: host "j05t06m4a0.execute-api.us-west-2.amazonaws.com" matched cert's "*.execute-api.us-west-2.amazonaws.com"
*  issuer: C=US; O=Amazon; OU=Server CA 1B; CN=Amazon
*  SSL certificate verify ok.
* Using HTTP2, server supports multiplexing
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7f81f1811a00)
> POST /test/helloworld?name=John&city=Seattle HTTP/2
> Host: j05t06m4a0.execute-api.us-west-2.amazonaws.com
> user-agent: curl/7.79.1
> accept: */*
> content-type: application/json
> day: Thursday
> content-length: 21
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
* We are completely uploaded and fine
< HTTP/2 200 
< date: Wed, 02 Nov 2022 06:18:19 GMT
< content-type: application/json
< content-length: 1763
< x-amzn-requestid: 5cee2b95-e5bb-4f7e-ab8c-bec43a193b81
< x-amz-apigw-id: a9bCvEhWvHcF2_Q=
< x-custom-header: my custom header value
< x-amzn-trace-id: Root=1-63620baa-3131234904b579687e30c50b;Sampled=0
< 
* Connection #0 to host j05t06m4a0.execute-api.us-west-2.amazonaws.com left intact
{"message":"Good evening, John of Seattle. Happy Thursday!","input":{"resource":"/helloworld","path":"/helloworld","httpMethod":"POST","headers":{"accept":"*/*","content-type":"application/json","day":"Thursday","Host":"j05t06m4a0.execute-api.us-west-2.amazonaws.com","User-Agent":"curl/7.79.1","X-Amzn-Trace-Id":"Root=1-63620baa-3131234904b579687e30c50b","X-Forwarded-For":"163.116.139.118","X-Forwarded-Port":"443","X-Forwarded-Proto":"https"},"multiValueHeaders":{"accept":["*/*"],"content-type":["application/json"],"day":["Thursday"],"Host":["j05t06m4a0.execute-api.us-west-2.amazonaws.com"],"User-Agent":["curl/7.79.1"],"X-Amzn-Trace-Id":["Root=1-63620baa-3131234904b579687e30c50b"],"X-Forwarded-For":["163.116.139.118"],"X-Forwarded-Port":["443"],"X-Forwarded-Proto":["https"]},"queryStringParameters":{"city":"Seattle","name":"John"},"multiValueQueryStringParameters":{"city":["Seattle"],"name":["John"]},"pathParameters":null,"stageVariables":null,"requestContext":{"resourceId":"islasg","resourcePath":"/helloworld","httpMethod":"POST","extendedRequestId":"a9bCvEhWvHcF2_Q=","requestTime":"02/Nov/2022:06:18:18 +0000","path":"/test/helloworld","accountId":"324320755747","protocol":"HTTP/1.1","stage":"test","domainPrefix":"j05t06m4a0","requestTimeEpoch":1667369898937,"requestId":"5cee2b95-e5bb-4f7e-ab8c-bec43a193b81","identity":{"cognitoIdentityPoolId":null,"accountId":null,"cognitoIdentityId":null,"caller":null,"sourceIp":"163.116.139.118","principalOrgId":null,"accessKey":null,"cognitoAuthenticationType":null,"cognitoAuthenticationProvider":null,"userArn":null,"userAgent":"curl/7.79.1","user":null},"domainName":"j05t06m4a0.execute-api.us-west-2.amazonaws.com","apiId":"j05t06m4a0"},"body":"{ \"time\": \"evening\" }","isBase64Encoded":false}}%     

### Retrospective 9.1

#### Task

Review other methods of creating microservices using API Gateway and
Lambda such as [Chalice](https://github.com/aws/chalice) (Python),
[Claudia.js](https://claudiajs.com/tutorials/index.html) (Node)
and [Aegis](https://github.com/tmaiaroto/aegis) (Go).
Understand how you can use [AWS SAM](https://github.com/awslabs/serverless-application-model)
to test and deploy Lambdas.

## Lesson 9.2: Lambda and other AWS resources

### Principle 9.2

*Lambda can interact with other AWS services when using the appropriate
execution policies.*

Coupling Lambda with native AWS services allows you to create powerful
code very quickly. Lambda can even be used with CloudWatch events to
perform complex log analysis or react with automated mitigation
functionality.

### Practice 9.2

#### Lab 9.2.1: Lambda with DynamoDB

As a simple example, let's extend your Lambda function to write data to
a table in DynamoDB:

- Start with the template and code you created in lab 2

- Add a DynamoDB table with several attributes of your choice

- Update the Lambda code to take input based on the attributes and
  insert new items into the DynamoDB table.

Test the code using an API call as you've done before. Confirm that the
call is inserting the item in the table.

Test Event Name
regularoldtestevent

Response
{
  "statusCode": 200,
  "body": "\"value1 and value2 {'key1': 'value1', 'key2': 'value2'} written successfully to Module9\""
}

Function Logs
START RequestId: e940a302-783f-4543-b106-ee4a22eae14d Version: $LATEST
END RequestId: e940a302-783f-4543-b106-ee4a22eae14d
REPORT RequestId: e940a302-783f-4543-b106-ee4a22eae14d	Duration: 1118.81 ms	Billed Duration: 1119 ms	Memory Size: 128 MB	Max Memory Used: 65 MB	Init Duration: 263.10 ms

Request ID
e940a302-783f-4543-b106-ee4a22eae14d

#### Lab 9.2.2: Lambda via CloudWatch Rules

CloudWatch rules can be used to call Lambda functions based on events.

- Add a CloudWatch rule to the template which targets your Lambda
  function when the S3 PutObject operation is called. If a trail
  doesn't exist for this, you may need to create one.

- Modify your Lambda handler to log some of the event data to the
  DynamoDB.

- Create an S3 bucket and test that the Lambda logs event data to the
  DB.

#### Lab 9.2.3: Query data with Lambda and API Gateway

Write another Lambda function that will query the DynamoDB table:

- The function should take a pattern (for instance, a bucket name) and
  return all events for that pattern.

- Add an API gateway that calls the Lambda to query the data.

### Retrospective 9.2

#### Question

*Can you think of practical ways an organization can use Lambda in
reaction to AWS resource changes?*

## Further Reading

- Read about [Capital One's Cloud Custodian project](https://stelligent.com/2017/05/15/cloud-custodian-cleans-up-your-cloud-clutter/)
  and see how it uses AWS Lambda.
