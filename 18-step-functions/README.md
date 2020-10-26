# Topic 18: Step Functions

<!-- TOC -->

- [Topic 18: Step Functions](#topic-18-step-functions)
  - [Guidance](#guidance)
  - [Lesson 18.1: Introduction to Step Functions](#lesson-181-introduction-to-step-functions)
    - [Principle 18.1](#principle-181)
    - [Practice 18.1](#practice-181)
      - [Lab 18.1.1: Create a State Machine in the AWS Console](#lab-1811-create-a-state-machine-in-the-aws-console)
        - [Question: Pass State](#question-pass-state)
        - [Question: States](#question-states)
        - [Question: Input and Output](#question-input-and-output)
    - [Retrospective 18.1](#retrospective-181)
      - [Question: Workflows](#question-workflows)
  - [Lesson 18.2: Lambda State Machine](#lesson-182-lambda-state-machine)
    - [Principle 18.2](#principle-182)
    - [Practice 18.2](#practice-182)
      - [Lab 18.2.1: Create a Lambda State Machine with CloudFormation](#lab-1821-create-a-lambda-state-machine-with-cloudformation)
        - [Question: Activity State Machine](#question-activity-state-machine)
    - [Retrospective 18.2](#retrospective-182)
      - [Question: Service Integrations](#question-service-integrations)
  - [Lesson 18.3: Step Functions and Events](#lesson-183-step-functions-and-events)
    - [Principle 18.3](#principle-183)
    - [Practice 18.3](#practice-183)
      - [Lab 18.3.1: Start an Execution in Response to a S3 Event](#lab-1831-start-an-execution-in-response-to-a-s3-event)
    - [Retrospective 18.3](#retrospective-183)
      - [Question: Other Events](#question-other-events)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Guidance

- Explore the official docs! See the AWS Step Functions
  [Developer Guide](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html),
  [API Reference](https://docs.aws.amazon.com/step-functions/latest/apireference/Welcome.html),
  and
  [CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/stepfunctions/index.html)
  docs.

- Avoid using other sites like stackoverflow.com for answers \-- part
  of the skill set you're building is finding answers straight from
  the source, AWS.

- Explore your curiosity. Try to understand why things work the way
  they do. Read more of the documentation than just what you need to
  find the answers.

## Lesson 18.1: Introduction to Step Functions

### Principle 18.1

*AWS Step Functions is a web service that enables you to coordinate the
components of distributed applications and microservices using visual
workflows.*

### Practice 18.1

Step Functions provides a reliable way to coordinate components and step
through the functions of your application. They are based on the concepts
of tasks and state machines, which are defined using the JSON-based
[Amazon States Language](https://states-language.net/spec.html). The Step
Functions console displays a graphical view of your state machine's
structure. This provides a way to visually check your state machine's
logic and monitor executions.

#### Lab 18.1.1: Create a State Machine in the AWS Console

Create a simple State Machine using the AWS console.

- Use the default "Author with code snippets" for _Define state machine_.

- Use the default "Standard" for _Type_.

- Update the code snippet to accept an input JSON property named _executioner_
  and output the following JSON object:
  {
    "executioner": "_Your Name_",
    "message": "Hello AWS!"
  }

- Give your state machine an appropriate name.

- Make a note of the new IAM role being created. You will need this when
  cleaning up the lab resources.

- Review the results and look at the step details after executing your
  state machine. Does the output look as expected?

- When you're done, delete the state machine and the IAM role.

##### Question: Pass State

_Describe the "Pass" state and what it does._

##### Question: States

_What are some of the other states you can use in a state machine?_

##### Question: Input and Output

_Describe how input and output are handled and manipulated in the step
functions._

### Retrospective 18.1

#### Question: Workflows

_When choosing a [workflow](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-standard-vs-express.html)
when is it recommended to use an Express workflow versus the Standard
workflow?_

## Lesson 18.2: Lambda State Machine

### Principle 18.2

*AWS Step Functions state machine can use an AWS Lambda function to
implement a Task state.*

### Practice 18.2

AWS Lambdas are well suited for implementing Task states, because
Lambda functions are stateless (they have a predictable input-output
relationship), easy to write, and don't require deploying code to a
server instance.

#### Lab 18.2.1: Create a Lambda State Machine with CloudFormation

Create a CFN template that creates a state machine, a lambda, and the
required IAM roles for those services when the stack is created:

- Lambda should return "Hello AWS!".

- The state machine should use the Lambda function to implement a task
  state.

- State machine execution should output "Hello AWS!"

##### Question: Activity State Machine

_What are some use cases for using an
[Activity State Machine](https://docs.aws.amazon.com/step-functions/latest/dg/tutorial-creating-activity-state-machine.html)
instead of the Lambda State Machine?_

### Retrospective 18.2

#### Question: Service Integrations

_What are some other supported AWS service integrations for Step Functions?_

## Lesson 18.3: Step Functions and Events

### Principle 18.3

*You can use Amazon CloudWatch Events to execute an AWS Step Functions
state machine in response to an event or on a schedule.*

### Practice 18.3

CloudWatch Events, such as uploading a new object to a S3 bucket, can be
used to trigger the execution of a state machine. This type of function
could be useful if you needed to perform operations on files that are
added to a bucket. This is also only a single example of the many types of
events that can trigger a state machine.

#### Lab 18.3.1: Start an Execution in Response to a S3 Event

Using the CFN template from the previous lab, make the following changes:

- Create a new S3 bucket.

- Create a new trail in CloudTrail that logs the events that occur in
  your new S3 bucket.

- Create a new CloudWatch rule to trigger the state machine when a file is
  uploaded to your new S3 bucket.

- Update the Lambda to return the name of the file uploaded.

- After the stack is updated, upload a file to your new S3 bucket and
  then review the execution log for your state machine execution.

- When you're done, delete the stack and all resources you created for
  these labs.

### Retrospective 18.3

#### Question: Other Events

_What are other types of events that can be used to trigger a state
machine execution?_

## Further Reading

- Read about [SAM integration](https://docs.aws.amazon.com/step-functions/latest/dg/sfn-local-lambda.html)
  for testing your step functions locally.

- Learn more about [handling error conditions](https://docs.aws.amazon.com/step-functions/latest/dg/tutorial-handling-error-conditions.html)
  in a state machine.

- Review [Step Functions Best Practices](https://docs.aws.amazon.com/step-functions/latest/dg/sfn-best-practices.html)
