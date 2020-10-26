# Serverless Application Model (SAM)

<!-- TOC -->

- [Serverless Application Model (SAM)](#serverless-application-model-sam)
  - [Guidance](#guidance)
  - [Lesson 16.1: Introduction to SAM](#lesson-161-introduction-to-sam)
    - [Principle 16.1](#principle-161)
    - [Practice 16.1](#practice-161)
      - [Lab 16.1.1: Creating a Serverless Application](#lab-1611-creating-a-serverless-application)
        - [Question: SAM Required Files](#question-sam-required-files)
      - [Lab 16.1.2: Exploring Events](#lab-1612-exploring-events)
      - [Lab 16.1.3: Running the Application Locally](#lab-1613-running-the-application-locally)
        - [Question: API Resource](#question-api-resource)
      - [Lab 16.1.4: Deploying the Application to AWS](#lab-1614-deploying-the-application-to-aws)
    - [Retrospective 16.1](#retrospective-161)
      - [Question: Capabilities Flag](#question-capabilities-flag)
      - [Question: Resources Created](#question-resources-created)
  - [Lesson 16.2: Integrating Components](#lesson-162-integrating-components)
    - [Principle 16.2](#principle-162)
    - [Practice 16.2](#practice-162)
      - [Lab 16.2.1: Integrating API Gateway](#lab-1621-integrating-api-gateway)
      - [Lab 16.2.2: Integrating SQS](#lab-1622-integrating-sqs)
        - [Question: Starting an API](#question-starting-an-api)
      - [Lab 16.2.3: Continuing the Pattern](#lab-1623-continuing-the-pattern)
    - [Retrospective 16.2](#retrospective-162)
  - [Lesson 16.3: Working with DynamoDB](#lesson-163-working-with-dynamodb)
    - [Principle 16.3](#principle-163)
    - [Practice 16.3](#practice-163)
      - [Lab 16.3.1: Working with DynamoDB Locally](#lab-1631-working-with-dynamodb-locally)
      - [Lab 16.3.2: Adding a DynamoDB Table Resource](#lab-1632-adding-a-dynamodb-table-resource)
        - [Question: Invoke the Function Directly](#question-invoke-the-function-directly)
      - [Lab 16.3.3: Working with DynamoDB Streams](#lab-1633-working-with-dynamodb-streams)
    - [Retrospective 16.3](#retrospective-163)
  - [Lesson 16.4: Deployment Strategies](#lesson-164-deployment-strategies)
    - [Principle 16.4](#principle-164)
    - [Practice 16.4](#practice-164)
      - [Lab 16.4.1: Working with the AutoPublishAlias](#lab-1641-working-with-the-autopublishalias)
      - [Lab 16.4.2: Working with CodeDeploy](#lab-1642-working-with-codedeploy)
      - [Lab 16.4.3: Working with CodeDeploy Deployment Hooks](#lab-1643-working-with-codedeploy-deployment-hooks)
        - [Question: Hook Failures](#question-hook-failures)
        - [Question: Missing CodeDeploy Resource](#question-missing-codedeploy-resource)
    - [Retrospective 16.4](#retrospective-164)
      - [Question: Canary and Linear Deployment Differences](#question-canary-and-linear-deployment-differences)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Guidance

- Explore the official docs! See the SAM [User Guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html),
  and
  [CLI Reference](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html).

- Avoid using other sites like stackoverflow.com for answers \-- part of
  the skill set you're building is finding answers straight from the
  source, AWS.

- Explore your curiosity. Try to understand why things work the way they
  do. Read more of the documentation than just what you need to find the
  answers.

## Lesson 16.1: Introduction to SAM

### Principle 16.1

*AWS SAM is an extension of AWS CloudFormation that simplifies serverless
application development by supplying local development tools and taking
care of a significant amount of boilerplate for serverless resource
declarations in CloudFormation templates.*

### Practice 16.1

Let's explore what SAM has to offer by using the CLI to initialize a
simple hello world application. In order to begin, the following
requirements must be met:

1. [Install](https://docs.docker.com/v17.09/engine/installation/) Docker
  to assist in developing and building the serverless application locally.

1. [Install](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
  the AWS SAM CLI.

1. Choose a [runtime](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
  to base the serverless application on. Make sure it is installed locally.
  This module will use `python3.7`.

#### Lab 16.1.1: Creating a Serverless Application

To begin working with SAM, the first thing we need to do is create a new
application.

- Use the SAM CLI to initialize a new application.

```bash
sam init --runtime python3.7
```

This will create a directory, `sam-app`, that has everything needed to
begin working with SAM. Note that a runtime can be specified on an
individual function basis.

Take a look at the `template.yaml` that was created. Notice the directive
at the top:

```yaml
Transform: AWS::Serverless-2016-10-31
```

This is what indicates to CloudFormation that SAM resources are being
used. Any SAM resource found in this template will be translated into
standard CloudFormation resources when the stack is deployed.

##### Question: SAM Required Files

_Though using `sam init` is a quick way to get started with a new project,
it is not required. What file(s) is/are required at a minimum to define a
new SAM application?_

#### Lab 16.1.2: Exploring Events

Notice that SAM has also created an `events` directory with a sample
`event.json` file. The particular event generated here is an
`apigateway aws-proxy` event.

Serverless applications are by nature highly dependent on events. It is
very important to become familiarized with using events locally. The SAM
CLI has [built in functionality](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-generate-event.html)
that makes working with events very easy.

- Run `sam local generate-event` to see a list of the different services
  events can be generated for.
- After reviewing the list of services, try running
  `sam local generate-event apigateway` to see a list of events that can
  be generated to mimic the Amazon API Gateway service.
- Looks at the different options available for an event by using the
  `--help` flag.

  ```bash
  sam local generate-event apigateway aws-proxy --help
  ```

- Use the `sam local generate-event` command to generate a new `aws-proxy`
  API Gateway event with a custom body.
- Save this new event to a file by redirecting the output to an
  `events/custom.json` file.
- Explore the different event types and options that can be generated for
  other services.

#### Lab 16.1.3: Running the Application Locally

In order to interact with the application we can invoke lambda functions
directly or we can spin up an API reachable at `localhost`.

- Invoke the lambda function directly.

  ```bash
  sam local invoke "HelloWorldFunction" -e events/event.json
  ```

- Start the api and curl the `/hello` endpoint integrated with the
  lambda function.

  ```bash
  sam local start-api
  ```

  ```bash
  curl http://127.0.0.1:3000/hello
  ```

It is also possible to configure
[environment variables](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#environment-object)
for local development. This is incredibly useful when working with lambda
functions that need environment variables present to perform their
function. With SAM it is possible to specify all environment variables in
a JSON file structured so each lambda function has its specific variables
defined.

- Update the lambda function to accept an environment variable called
  `NAME`.
- Create a file called `env.json`
- Add the following JSON to the `env.json` file. Notice namespace of
  variables by the lambda functions Logical ID.

  ```json
      {
        "HelloWorldFunction": {
          "NAME": "<name>"
        }
      }
  ```

- Update the function to print out the `NAME` environment variable.
- Invoke the lambda function independently with `--env-vars env.json`.
- Start the api with `--env-vars env.json` and access the endpoint.

Ensure that accessing the function directly via `invoke` as well as
accessing it behind an API via `start-api` both log the expected
environment variable.

##### Question: API Resource

_There was no API resource defined in the SAM template, how is it
possible to start one and call it?_

#### Lab 16.1.4: Deploying the Application to AWS

After the application has been created, it is simple to deploy it. SAM
uses the same mechanism as the AWS CLI for CloudFormation to package and
deploy templates, in fact, they are completely interchangeable.

Before the template can be deployed an Amazon S3 bucket must be created
to store packaged artifacts.

- Create an S3 bucket using the AWS CLI.

  ```bash
  aws s3 mb s3://<bucket> --region <region>
  ```

Once the bucket is created, the application can be built and packaged.

- Run the SAM CLI build and package commands.

  ```bash
  sam build && sam package --output-template packaged.yaml --s3-bucket <bucket>
  ```

Look at the output template that was created, `packaged.yaml`. Notice that
the `CodeUri` that pointed to the local function code in `template.yaml`
now points to an object stored in the S3 bucket that was referenced. This
is the packaged HelloWorld function.

Everything is now ready to be deployed. Name the stack so that it can be
easily referenced in AWS and will not conflict with any other stacks.

- Run the SAM CLI deploy command.

  ```bash
  sam deploy --template-file packaged.yaml --capabilities CAPABILITY_IAM \
  --stack-name <stack>
  ```

### Retrospective 16.1

#### Question: Capabilities Flag

_What happens when the stack is deployed without the `--capabilities` flag?
The template has not referenced any IAM Roles to be created, why does the
flag need to be supplied?_

- Inspect the stack outputs using the AWS CLI.

  ```bash
  aws cloudformation describe-stacks --stack-name <stack> \
  --query "Stacks[].Outputs"
  ```

The endpoint URL for the API should be returned. Try curling it. Ensure
the received response is the one expected. If it was, go ahead and tear
the stack back down, otherwise investigate what went wrong.

#### Question: Resources Created

_What resources were created for this stack that were not explicitly
defined in the template?_

```bash
aws cloudformation delete-stack --stack-name <stack>
```

## Lesson 16.2: Integrating Components

Before we start adding more components, review the different
[resource types](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#resource-types)
SAM can enhance CloudFormation with.

### Principle 16.2

*SAM resources can coexist in the same template as standard CloudFormation
resources. Everything that works with CloudFormation works with SAM. SAM
can be used to locally simulate events that would occur on AWS.*

### Practice 16.2

#### Lab 16.2.1: Integrating API Gateway

To explore some of the ways API Gateway and Lambda interact through SAM,
create another project called 'sam-api'.

> `sam init --name sam-api --runtime python3.7`

Often times it is necessary to pass parameters in the query portion of an
API call. Accessing these variables in the lambda function is straight
forward.

- Update the function by replacing the `body` value with
  `event['queryStringParameters']` for the return value.
- Start the API and curl `localhost:3000/hello?id=1`.

The function should have returned a JSON representation of all the query
parameters. Additionally, it is possible to access the path parameters of
a request if the path is configured to accept them.

- Update the `Events` declaration on the Lambda function by changing the
  `Path` from `/hello` to `/hello/{id}`.
- Update the function by replacing the `body` value with
  `event['pathParameters']` for the return value.
- Start the API and curl `localhost:3000/hello/1`.

The function should have returned a JSON representation of the path
parameters.

- Generate an event file that can be used to `invoke` the function with a
  path parameter for `id`.

#### Lab 16.2.2: Integrating SQS

In previous exercises, new projects have been created with the SAM CLI
`init` command. This time, rather than use the CLI, simply create a new
directory, `sam-sqs`, and add a `template.yaml`.

- Create a new directory, `sam-sqs`, to house the new application.
- Add a `template.yaml` file and add the appropriate declarations to
  specify this as a SAM application.
- Run `sam validate` to ensure the template is valid. If it is not, refer
  to the template generated in the last lab to determine why.

Add a lambda function and an SQS queue to handle processing the queue's
messages.

- Add an `AWS::Serverless::Function` resource named `ProcessSqsFunction`
  with a python3.7 runtime to the application and use the following code:

  ```python
  def lambda_handler(event, context):
      for record in event['Records']:
        payload=record["body"]
        print(str(payload))
  ```

- Add an `AWS::SQS::Queue` resource to the template.
- Reference the Queue in a [new event entry](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#sqs)
  definition.
- Generate a new SQS event.

  ```bash
  sam local generate-event sqs receive-message
  ```

The SAM `invoke` command can use accept an event with the `-e` flag or
by reading from stdin.

- Ensure the function behaves as expected by invoking it with the
  generated SQS event using a pipe (`|`) and by passing the `-e` argument.
- Deploy the application with the `sam build`, `sam package`, and
  `sam deploy` commands.
- Use the AWS CLI to [send a message](https://docs.aws.amazon.com/cli/latest/reference/sqs/send-message.html)
  to the queue. Review the functions logs in CloudWatch - are the results
  as expected?

##### Question: Starting an API

_What happens if we try to start an api locally without having one
implicitly defined?_

#### Lab 16.2.3: Continuing the Pattern

At this point it should be apparent how to create event-driven
architectures locally using SAM and generated events to mimic real world
behavior.

For this lab, build an application that logs filenames written to S3 using
SNS. Refer to [Using AWS Lambda  with Other Services](https://docs.aws.amazon.com/lambda/latest/dg/lambda-services.html)
for examples if difficulty arises.

- Create a Lambda function that is triggered anytime a new object is added
  to a specific S3 bucket.
- Create an SNS topic and configure the lambda function to accept its ARN
  using lambda environment variables.
- Have the lambda function publish a new message to an SNS topic
  containing the name of the file. [`boto3`](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html#SNS.Client.publish)
  will be required for this. Use the ARN configured in the environment.
- Create another lambda function that is subscribed to the SNS topic that
  will log the filename of the object originally placed in S3.

### Retrospective 16.2

...

## Lesson 16.3: Working with DynamoDB

### Principle 16.3

*While it is relatively simple to manipulate lambda functions with events
and the SAM CLI locally, interacting with a service like DynamoDB poses
some difficulty. Fortunately, Amazon has created a Docker image that
enables developers to work with it locally.*

### Practice 16.3

#### Lab 16.3.1: Working with DynamoDB Locally

Getting DynamoDB running locally is just a matter of running the image in
a container, providing Docker is installed.

- Start DynamoDB using Docker with the following command:

  ```bash
  docker run -p 8000:8000 amazon/dynamodb-local
  ```

- Ensure DynamoDB is reachable.

  ```bash
  aws dynamodb list-tables --endpoint-url http://localhost:8000
  ```

The response from DynamoDB should list the (currently nonexistent) tables.

#### Lab 16.3.2: Adding a DynamoDB Table Resource

- Create a new application, and add an `AWS::Serverless::SimpleTable`
  resource to the template with a primary key of 'id'.
- Add an `AWS::Serverless::Function` resource called `WriteFunction` to
  create entries in the DynamoDB table.
- Update the `WriteFunction` resource to accept an environment variable,
  `TABLE_NAME` and reference the DynamoDB table. Note that because SAM
  local does not actually create a DynamoDB table, any `!Ref` will fall
  back to the Logical ID of the resource.
- Add an event to the `WriteFunction` so that it will be triggered from
  an API `GET` the `/write` path.

To ensure the function is working, have it write out the `TABLE_NAME`
environment variable to the console.

Curl the API `write` endpoint using `sam local start-api` and check the
log prints the expected table name - it should be the Logical ID, not the
name set in properties.

Build, package, and deploy the application, then test it in the cloud.
Ensure everything works as it did locally by calling the endpoint and
checking the CloudWatch logs for the table name.

##### Question: Invoke the Function Directly

_What happens if we try to invoke the function directly without the api?
Can you determine a way to invoke the function directly?_

 Next, create the table in the local DynamoDB instance. Provided is some
 JSON with a table definition. Replace the TableLogicalID value with the
 name used in the SAM template definition and run the following:

```bash
aws dynamodb create-table --cli-input-json file://create-table.json \
--endpoint-url http://localhost:8000
```

Now that the table is created, update the `WriteFunction` to create
records. In order to support our local DynamoDB some additional logic
needs to be added to the function:

```python
table_name = os.getenv('TABLE_NAME')
if os.getenv('AWS_SAM_LOCAL'):
  table = boto3.resource('dynamodb', endpoint_url="<endpoint>").Table(table_name)
else:
  region = os.getenv('AWS_REGION')
  table = boto3.resource('dynamodb', region_name=region).Table(table_name)
```

Notice the endpoint used while running this function locally, it will
need to reflect the machine the function is running on. (Additionally, a
docker network could be created and used to start the DynamoDB container
and `sam local start-api --docker-network <network>`. This would allow
the function to reference `dynamodb:8000` in any development environment,
though this will be left as an exercise to the interested reader.)

- Mac: `http://docker.for.mac.localhost:8000/`
- Windows: `http://docker.for.windows.localhost:8000/`
- Linux: `http://127.0.0.1:8000/`

- Finally, add code to insert an item into the table:

  ```python
  table.put_item(Item={'id': str(uuid.uuid4())})
  ```

Run the API locally and curl the `/write` endpoint. If everything worked
as it should, the following command should indicate new records were
indeed added to the local table:

```bash
aws dynamodb scan --table-name <table_name> --endpoint-url http://localhost:8000
```

#### Lab 16.3.3: Working with DynamoDB Streams

After verifying the application works - implement the resources needed to
trigger a new lambda function when stream events occur on the table.

- Create another `AWS::Serverless::Function` resource called
  `ProcessStreamEventsFunction`.
- Use the following code for the body of the
  `ProcessStreamEventsFunction`:

  ```python
    def lambda_handler(event, context):
        for record in event['Records']:
          print(record['eventID'])
          print(record['eventName'])
  ```

- Add a `StreamSpecification` to the table resource.
- Add a [DynamoDB event type](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#dynamodb)
  to the function that references the stream we added to the DynamoDB
  table.
- Running `sam validate` at this point should indicate that the SAM
  resource `AWS::Serverless::SimpleTable` is no longer robust enough for
  the functionality required by the application. Update the resource type
  to accommodate the `StreamSpecification` property.

DynamoDB will not trigger stream events locally. To test it, the SAM CLI
will be needed to trigger a stream event manually.

- Ensure the `ProcessStreamEventsFunction` is working correctly by
  building it and invoking it locally with the
  [`generate-event`](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-generate-event.html)
  command.

While this function works locally with DynamoDB, a policy will need to be
specified to allow the lambda function to work with DynamoDB on AWS.

- Find the [appropriate policy](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-templates.html).
  Add it to the lambda function under the `Policies` property.

Once the policy is in place, `package` and `deploy` the application. After
it has deployed, try calling the `/write` endpoint.

Did the function execute properly and insert data into the DynamoDB
table? If not debug the issue.

### Retrospective 16.3

...

## Lesson 16.4: Deployment Strategies

### Principle 16.4

*As best practice, it is necessary to deploy applications in a way that
minimizes risk. AWS SAM assists with this by building in different
deployment patterns for shifting traffic between old and new versions of
the application.*

### Practice 16.4

It is advisable to get familiar with the overall concept of SAM and Lambda
deployment before proceeding into this section. The following resources
will provide a solid outline of what is to be accomplished in this lesson:

- [Safe Lambda Deployments](https://github.com/awslabs/serverless-application-model/blob/master/docs/safe_lambda_deployments.rst)
- [CodeDeploy SAM Deployments](https://docs.aws.amazon.com/codedeploy/latest/userguide/tutorial-lambda-sam.html)

#### Lab 16.4.1: Working with the AutoPublishAlias

Adding an `AutoPublishAlias` property to an `AWS::Serverless::Function`
accomplishes a few things.

1. CloudFormation detects when the functions code has changed from the
  previous version by comparing the functions Amazon S3 URI.
1. If a change is detected, it will create a new version of the function
  and publish it, making it immutable.
1. After the new function is published, it will create an alias, or point
  the existing alias, to the newly published version of the function.

- To get more familiar with these concepts, create a new SAM application.

  ```bash
  sam init --runtime nodejs8.10
  ```

- Add a the `AutoPublishAlias` property to the generated function and give
  it a value of `live`.
- Build, package, and deploy the application.

After the application has been deployed, inspect the stack to view the
alias that was created.

- Copy the function ARN from the following command:

  ```bash
  aws cloudformation describe-stacks --stack-name <stack> --query "Stacks[].Outputs"
  ```

- Use the `aws lambda list-aliases` command with the function ARN to get
  back a list of aliases.

Take note of the function version returned from the AWS CLI. After the
alias creation has been verified, alter the code in the function, then
build, package, and deploy it again.

- List the aliases for the function again.
- Build, package, and deploy the application again.

Notice how the alias automatically points to the newest version of
the function.

#### Lab 16.4.2: Working with CodeDeploy

Now that the function alias is automatically updating on deployment, SAM
can utilize different deployment strategies to shift traffic from one
version of the function to another using AWS CodeDeploy. Update the
function declaration to utilize a deployment type.

- Add a [`DeploymentPreference`](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#deploymentpreference-object)
  property to the function with a `Type` specified as
  `Linear10PercentEvery10Minutes`.
- Alter the functions code.
- Build, package, and deploy the application.
- Navigate to the CloudFormation web console and view the resources for
  the stack.
- Find the 'ServerlessDeploymentApplication' resource and navigate to it.
- Navigate to the Deployments tab, then click the listed deployment.

The current status of the lambda deployment is listed here. Notice how
traffic is shifting between the two versions of the function.

#### Lab 16.4.3: Working with CodeDeploy Deployment Hooks

CodeDeploy operates using hooks that are called during the deployment
lifecycle. It is possible to specify hooks for the lambda deployment as
part of the `DeploymentPreference` specification. By utilizing these
hooks, a newly deployed function can be verified to be working before
allowing traffic and after allowing traffic. If the deployment receives a
'Failed' status in any of the hooks, the deployment is rolled back to the
previous version.

- Add the supplied `lifecycleHook.js` file to the project.
- Add the resources defined in the supplied `codeDeployResources.yml`
  file to the project.
- Replace the instances of `<Function>` with the logical id of the
  function the hooks are being added to.
- Add a `Hooks` property to the `DeploymentPreference` specification and
  reference the two hook functions that were just added.

  ```yaml
    DeploymentPreference:
        Hooks:
          PreTraffic: !Ref beforeAllowTraffic
          PostTraffic: !Ref afterAllowTraffic
  ```

- Run `sam validate` and fix any issues preventing the template from
  validating.
- Package and deploy the application.
- Navigate to the deployment created.

CodeDeploy is now using the lambda functions defined in the application
as hooks to validate the deployment. While currently the same code is
being used for the before and after traffic hooks, it is possible (and
likely) to have different code validating each hook. This is a powerful
tool that is very useful in deploying a serverless application and
ensuring the integration works as expected.

##### Question: Hook Failures

_What happens if the `lifecycleHook.js` file returns a `Failed` status
instead of succeeded?_

##### Question: Missing CodeDeploy Resource

_You never specified a CodeDeploy resource to handle the deployment for
the function, how did CloudFormation know to create one?_

### Retrospective 16.4

#### Question: Canary and Linear Deployment Differences

_What is the difference between canary deployments and linear deployments?_

## Further Reading

- [Virtual Env](https://docs.python.org/3/tutorial/venv.html)
- [AWS::Serverless::Application Resource](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template.html#serverless-sam-template-application)
