# 1. Topic 19: AWS Cloud Development Kit (CDK)

- [1. Topic 19: AWS Cloud Development Kit (CDK)](#1-topic-19-aws-cloud-development-kit-cdk)
  - [1.1. Conventions](#11-conventions)
  - [1.2. Lesson 19.1: Introduction to CDK](#12-lesson-191-introduction-to-cdk)
    - [1.2.1. Principle 19.1](#121-principle-191)
    - [1.2.2. Practice 19.1](#122-practice-191)
      - [Lab 1.1.1: CloudFormation Template Requirements](#lab-111-cloudformation-template-requirements)
  - [1.3. References](#13-references)
  - [1.4. Additional Reading / Videos](#14-additional-reading--videos)

****

## 1.1. Conventions

- CDK templates can be any supported language: Python, TypeScript, JavaScript,
  Java, or C#. XX Python preferred?

- Do NOT copy and paste templates from the internet at large

- DO use the [CDK Developer Guide](https://docs.aws.amazon.com/cdk/latest/guide/home.html)
  and [CDK API Reference](https://docs.aws.amazon.com/cdk/api/latest/docs/aws-construct-library.html)

- Familiariity with [AWS CloudFormation](https://aws.amazon.com/cloudformation/)
  is useful, as CDK outputs a CFN template.

- DO utilize every link in this document; note how the AWS documentation is
  laid out

- DO use the [AWS CDK Toolkit (cdk
  command)](https://docs.aws.amazon.com/cdk/latest/guide/cli.html) (NOT the
  Console) unless otherwise specified.

## 1.2. Lesson 19.1: Introduction to CDK

### 1.2.1. Principle 19.1

A CDK template is an alternate interface to build AWS resources, comparable to CloudFormation.

### 1.2.2. Practice 19.1

A CDK Template, like a CFN Template, is a set of instructions for creating AWS
resources. In CDK, code defines an "App", which defines the resources. The app
is rendered or "synthesized" into a CloudFormation Template. This can be
examined for issues, or can be deployed to create a CFN Stack and the assocated
real AWS resources like SQS Queues and Lambda functions.

#### Lab 1.1.1: CloudFormation Template Requirements

Create the *most minimal CDK app possible* that can be used to
create an minimal Lambda handler.

- Choose a CDK language to write your apps.

- Follow the [AWS CDK
  Worshop](https://cdkworkshop.com/30-python/30-hello-cdk/200-lambda.html) to
  get CDK set up.

- Follow the Workshop to build the resources for a simple Lambda handler app.
  Use the CLI tool "cdk". Use your preferred region.

- Note the output. XX compare outputs to information available in the Console.

- XX compare the App's info to a CloudFormation Stack. Does the App *generate* a
  Stack?

- XX Questions:
  - how can the Lambda be tested?
  - what happens if the deploy has an error, how can the issue be diagnosed and resolved?

- Commit the template to your Github repository under the `19-cdk` folder.

## 1.3. References

- [AWS CDK Examples (GitHub)](https://github.com/aws-samples/aws-cdk-examples)

- [AWS CDK Workshop](https://cdkworkshop.com/)

## 1.4. Additional Reading / Videos

Related topics to extend your knowledge about CDK:

- [good CDK blog posts](https://garbe.io/category/cdk/)

- CDK: there's a [CRUD app written via API Gateway
  integrations](https://github.com/aws-samples/aws-cdk-examples/blob/master/python/my-widget-service/my_widget_service/my_widget_service_stack.py)
  in ~100 lines!

- [Exploring CDK Internals (YouTube)](https://youtu.be/X8G3G3SnCuI)

- CDK Workshop site is statically generated, and [managed via CDK](https://github.com/aws-samples/aws-cdk-intro-workshop/tree/master/cdkworkshop.com)
