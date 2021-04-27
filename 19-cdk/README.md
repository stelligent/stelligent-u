TODO

- XX import/migrate CFN template! [Use CFN Template](https://docs.aws.amazon.com/cdk/latest/guide/use_cfn_template.html)

- XX [CDK Pipeline!](https://docs.aws.amazon.com/cdk/latest/guide/cdk_pipeline.html)

# 19. Topic 19: AWS Cloud Development Kit (CDK)

- [19. Topic 19: AWS Cloud Development Kit (CDK)](#19-topic-19-aws-cloud-development-kit-cdk)
  - [19.1. Conventions](#191-conventions)
  - [Lesson 19.1: Introduction to CDK](#lesson-191-introduction-to-cdk)
    - [Principle 19.1](#principle-191)
    - [Practice 19.1](#practice-191)
      - [Lab 19.1.1: CloudFormation Template Requirements](#lab-1911-cloudformation-template-requirements)
      - [Lab 19.1.X: Clean up](#lab-191x-clean-up)
    - [Retrospective 19.1](#retrospective-191)
      - [Question: Why code vs YAML](#question-why-code-vs-yaml)
  - [Lesson 19.2: Integration with Other AWS Resources](#lesson-192-integration-with-other-aws-resources)
    - [Principle 19.2](#principle-192)
    - [Practice 19.2](#practice-192)
      - [Lab 19.2.1: Cross-Referencing Resources within a single App](#lab-1921-cross-referencing-resources-within-a-single-app)
      - [Lab 19.2.2: Exposing Resource Details via Exports](#lab-1922-exposing-resource-details-via-exports)
      - [Lab 19.2.3: Importing another Stack's Exports](#lab-1923-importing-another-stacks-exports)
  - [19.3. References](#193-references)
  - [19.4. Additional Reading / Videos](#194-additional-reading--videos)

****

## 19.1. Conventions

- CDK templates can be any supported language: Python, TypeScript, JavaScript,
  Java, or C#.

- Do NOT copy and paste templates from the internet at large

- DO use the [CDK Developer
  Guide](https://docs.aws.amazon.com/cdk/latest/guide/home.html) especially the
  [Concepts](https://docs.aws.amazon.com/cdk/latest/guide/core_concepts.html)
  and
  [CDK API
  Reference](https://docs.aws.amazon.com/cdk/api/latest/docs/aws-construct-library.html)
  sections. The Guide is available by running `cdk docs`

- Familiariity with [AWS CloudFormation](https://aws.amazon.com/cloudformation/)
  is useful, as CDK outputs a CFN template.

- DO utilize every link in this document; note how the AWS documentation is
  laid out.

- DO use the [AWS CDK Toolkit (cdk
  command)](https://docs.aws.amazon.com/cdk/latest/guide/cli.html) (NOT the
  Console) unless otherwise specified.

- Consider installing the [AWS Toolkit for Visual Studio Code](https://docs.aws.amazon.com/cdk/latest/guide/vscode.html)

- Note that the CDK requires more setup than raw CloudFormation, it
  needs to be _bootstrapped_: [CDK Bootstrapping](https://docs.aws.amazon.com/cdk/latest/guide/bootstrapping.html)

## Lesson 19.1: Introduction to CDK

### Principle 19.1

A CDK template is an alternate interface to build AWS resources, comparable to CloudFormation.

### Practice 19.1

A CDK Template, like a CFN Template, is a set of instructions for creating AWS
resources. In CDK, code defines an "App", which defines the resources. The app
is rendered or "synthesized" into a CloudFormation Template. This can be
examined for issues, or can be deployed to create a CFN Stack and the assocated
real AWS resources like SQS Queues and Lambda functions.

#### Lab 19.1.1: CloudFormation Template Requirements

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

#### Lab 19.1.X: Clean up

- List the assets once this lesson's Stacks have been
  deleted to ensure their removal.

### Retrospective 19.1

#### Question: Why code vs YAML

_What are the tradeoffs of using a code language for resources, vs
YAML?_

_If a project has multiple microservices, and they're in different languages,
how can each re-use shared modules?_

## Lesson 19.2: Integration with Other AWS Resources

### Principle 19.2

CDK integrates well with the rest of the AWS ecosystem

### Practice 19.2

A CDK app's resources can reference: each other's attributes,
resource attributes exported from other Stacks in the same region, and
Systems Manager Parameter Store values in the same region. This provides
a way to have resources build on each other to create your AWS
ecosystem.

#### Lab 19.2.1: Cross-Referencing Resources within a single App

Create a CDK app that describes two resources: an IAM User, and an
IAM Managed Policy that controls that user.

- The policy should allow access solely to 'Read' actions against all
  S3 Buckets (including listing buckets and downloading individual bucket contents)

- Attach the policy to the user via the app.

- Use a [CDK
  Parameter](https://docs.aws.amazon.com/cdk/latest/guide/parameters.html) to
  set the user's name

- Create the App.

#### Lab 19.2.2: Exposing Resource Details via Exports

Update the app by adding a CFN Output that exports the Managed
Policy's Amazon Resource Name ([ARN](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)).

- Update the App.

- [List all the Stack Exports](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/list-exports.html)
  in that App's region.

#### Lab 19.2.3: Importing another Stack's Exports

Create a *new* App that describes a new IAM User and applies to it
the Managed Policy ARN created by and exported from the previous Stack.

- Create this new App.

- [List all the Stack Imports](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/list-imports.html)
  in that stack's region.

## 19.3. References

- [AWS CDK Examples (GitHub)](https://github.com/aws-samples/aws-cdk-examples)

- [AWS CDK Workshop](https://cdkworkshop.com/)

- [AWS CDK Developer Guide](https://docs.aws.amazon.com/cdk/index.html)
  including
  [Examples](https://docs.aws.amazon.com/cdk/latest/guide/examples.html)

## 19.4. Additional Reading / Videos

Related topics to extend your knowledge about CDK:

- [good CDK blog posts](https://garbe.io/category/cdk/)

- CDK: there's a [CRUD app written via API Gateway
  integrations](https://github.com/aws-samples/aws-cdk-examples/blob/master/python/my-widget-service/my_widget_service/my_widget_service_stack.py)
  in ~100 lines!

- [Exploring CDK Internals (YouTube)](https://youtu.be/X8G3G3SnCuI)

- CDK Workshop site is statically generated, and [managed via CDK](https://github.com/aws-samples/aws-cdk-intro-workshop/tree/master/cdkworkshop.com)
