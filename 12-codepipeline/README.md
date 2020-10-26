# Topic 12: CodePipeline

<!-- TOC -->

- [Topic 12: CodePipeline](#topic-12-codepipeline)
  - [Conventions](#conventions)
  - [Lesson 12.1: Introduction to CI/CD in AWS](#lesson-121-introduction-to-cicd-in-aws)
    - [Principle 12.1](#principle-121)
    - [Practice 12.1](#practice-121)
      - [Lab 12.1.1](#lab-1211)
      - [Lab 12.1.2](#lab-1212)
    - [Retrospective 12.1](#retrospective-121)
      - [Question: CloudFormation Template](#question-cloudformation-template)
      - [Question: Pipeline Template](#question-pipeline-template)
      - [Task](#task)
  - [Lesson 12.2: Pipelines Support Infrastructure as Code](#lesson-122-pipelines-support-infrastructure-as-code)
    - [Principle 12.2](#principle-122)
    - [Practice 12.2](#practice-122)
      - [Lab 12.2.1](#lab-1221)
      - [Lab 12.2.2](#lab-1222)
      - [Lab 12.2.3](#lab-1223)
    - [Retrospective 12.2](#retrospective-122)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Conventions

- All CloudFormation templates should be written in YAML.

- Do NOT copy and paste CloudFormation templates from the Internet at large.

- DO use the [CloudFormation documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)

- DO utilize every link in this document; note how the AWS documentation is
  laid out.

- DO use the [AWS CLI for CloudFormation](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/index.html#)
  (NOT the Console) unless otherwise specified.

## Lesson 12.1: Introduction to CI/CD in AWS

### Principle 12.1

*Pipelines are how Stelligent delivers infrastructure, software, custom
environments and processes, and just about everything else.*

### Practice 12.1

The CI/CD landscape is full of rich and full-featured tools, and no two
organizations seem to use the same tool-set. As a result, there
will be some learning curve on every project, and here we'll introduce
some of the AWS-native tools. CodePipeline integrates well with
CloudFormation, Lambda and other AWS resources. CodeBuild provides an
extension of innate CodePipeline capabilities by providing customizable
execution environments to perform custom, codified actions.

This innate tool-set has its weaknesses as well, such as integration
with only GitHub and S3 as 'sources' of code (and perhaps a sub-par
organization of the documentation). However, *the ability and relative
ease with which we can codify and version a pipeline, all without a CI
server, is a very desirable advantage*.

*HINT:* Organizing your references to critical parts of AWS
documentation will probably be helpful.

[https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/continuous-delivery-codepipeline.html](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/continuous-delivery-codepipeline.html)

#### Lab 12.1.1

Code a CFN template that generates a
[CodePipeline Pipeline](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-pipeline.html)
and its minimal set of requisite resources:

- Add an S3 bucket for maintaining Pipeline execution state

- Add an IAM [execution role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-service.html)
  that trusts the CodePipeline service and provides sufficient
  permissions to [deploy cloudformation](https://docs.aws.amazon.com/codepipeline/latest/userguide/how-to-custom-role.html).

- Add an IAM execution role that trusts CloudFormation to create an S3
  bucket.

- Add the CodePipeline Pipeline resource itself, encoding
  - a 'Source' stage to retrieve the code from GitHub
    - Create a [GitHub personal access token](https://github.com/settings/tokens)
    - Poll the repository for changes to the master branch
  - a 'Deploy' stage with an action that executes
    [this CFN template](https://github.com/stelligent/stelligent-u/blob/master/12-codepipeline/bucket.yaml)
    and creates an S3 bucket

Deploy the Pipeline stack via the AWS CLI; its creation should
automatically initiate the first Pipeline execution.

#### Lab 12.1.2

Add two new stages to your pipeline, utilizing CodeBuild:

- A 'Build' stage with a single action, encoding commands to validate
  the 'application' CFN template using the AWS CLI

  - follows immediately after the Source stage

- A 'Test' stage, again with a single action, that validates the
  'application' stack is in a healthy state

  - Follows immediately after the 'Deploy' stage

Make sure you understand how CodeBuild projects work prior to coding
them, including the CFN resources you need:

- an IAM execution role that trusts the CodeBuild service and provides
  sufficient permissions to perform the actions required by the
  actions in the 'Build' and 'Test' stages

- the CodeBuild resources themselves, including build specs

### Retrospective 12.1

#### Question: CloudFormation Template

_Is executing a CloudFormation template a legitimate example of an
"application"? Provide an explanation._

#### Question: Pipeline Template

_Is your Pipeline template portable? Update and re-create your Pipeline if
you hard-coded any of the following:_

- the name of the 'application' stack

- the repository name, the branch to track, or personal access token

- the S3 bucket name

- anything else that might enhance portability

#### Task

Delete your pipeline stack and leave your bucket stack alone. Once the
pipeline stack is gone try to delete the bucket stack. What happens? You
likely won't be able to delete it because of missing roles. The order
you delete stacks and which stack your define resources in can become a
dependency web. To delete your bucket stack you can recreate your
pipeline stack and use the created roles to recreate the missing role
for your orphaned bucket stack. To help avoid this in the future it's a
good idea to define your roles in a separate stack and use the outputs
in your other stacks.

## Lesson 12.2: Pipelines Support Infrastructure as Code

### Principle 12.2

*All AWS resources used by an application are part of that application's
infrastructure and should be versioned code, just like the application
itself, and delivered through automation pipelines.*

### Practice 12.2

Well-architected software applications built in the cloud should take
advantage of existing services wherever possible, to reduce the level of
effort required to code and maintain the business logic that makes the
application valuable to its consumers. Although the term
[infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_Code)
was originally coined for virtual servers, in AWS it should be used to
describe all the AWS resources utilized by an application or application
stack.

Pipelines that once supported building and deploying applications can
now easily build and deploy the entirety of an application stack, from
networking elements and services that make an application
highly-available to storage and monitoring resources that provide a
functional and secure environment in which the application operates.

These labs will assume we're building an inventory application that
allows us to track stock of bicycle parts. We won't actually create that
application, but we will create the DynamoDB table that will serve as
the inventory.

#### Lab 12.2.1

Create an application infrastructure CFN template that generates the
following. For the Table, keep it as simple as possible - add ID as the
primary partition key

- a DynamoDB table, as described

- a Role that uses an AWS managed policy that will allow a fictional
  application the enough access to the DynamoDB service to read and
  write records to the table

  - You can use AmazonDynamoDBReadOnlyAccess or any other policy
    since we won't actually access our database

Use the template:

- Create a stack using this template to ensure it functions as
  expected

- Delete this stack once the template is working.

#### Lab 12.2.2

Create a pipeline that leverages CodePipeline and CodeBuild to deploy
the application stack (the table you just designed), with these
requirements:

- the pipeline should use a [CloudFormation ChangeSet](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html)
  to either deploy or update the application stack

- the *first* time the pipeline is executed, it should create the
  stack using a 'CREATE' type of ChangeSet

- each *subsequent* pipeline execution should update the stack, again
  using an 'UPDATE' type of ChangeSet

The Pipeline should therefore have a Source stage and a Deploy stage,
and the Deploy stage should consist of two actions:

- creating the ChangeSet

  - this is like a dry-run, which allows us to examine *what would
    have happened* if we had simply created or updated the stack

- executing the ChangeSet

  - this *actually applies the changes* that were laid out when the
    ChangeSet was created

#### Lab 12.2.3

The previous Lab used a combination of *creating* and then *executing* a
ChangeSet to generate a DynamoDB table for our hypothetical application.
Why did we bother? We could have just created the stack in a single step
and been done!

Database data can be a vital resource and we want to protect it from
accidental deletion[^1]. Once a DynamoDB table is created via
CloudFormation, a template or parameter value change *that renames the
table* will actually cause the table to be dropped and recreated. If you
have data in the table, it will be lost as well. Let's exercise a simple
precaution to prevent this by taking advantage of a built-in
CodePipeline feature: an Approval action.

- Add an Approval action between the 'creation' and 'execution' of the
  ChangeSet in the Pipeline's Deploy stage

  - this pauses the pipeline, allowing you to query and analyze the
    ChangeSet

- If the ChangeSet wants to drop and recreate your DynamoDB table,
  reject the continuation of the pipeline

- Otherwise, approve the continuation of the pipeline, allowing the
  pipeline to continue creating or updating the application stack.

### Retrospective 12.2

Commit a change to the master branch of your repository to
demonstrate how using ChangeSets and the Pipeline Approval features can
help guard against dropping and recreating the table.

## Further Reading

- Validating the CFN template right before deploying the stack isn't
  really that helpful since stack creation/update will validate it
  as well. Using a tool like [cfn_nag](https://github.com/stelligent/cfn_nag)
  would be a better test of your CFN template.

- Manual approval of a change set can also
  [generate a notification](https://docs.aws.amazon.com/codepipeline/latest/userguide/approvals.html)
  to stakeholders so that users know when to review the application.

[^1]: For the record, there are other ways of protecting AWS resources
    from being accidentally deleted, generally involving being very
    selective with access permissions. This exercise demonstrates
    another mechanism that can be more generally applicable.
