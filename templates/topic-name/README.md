# Topic: Topic Name

<!-- TOC -->

- [Guidance](#guidance)
- [Lesson 1: Introduction to Topic name](#lesson-1-introduction-to-topic-name)
  - [Principle 1](#principle-1)
  - [Practice 1](#practice-1)
    - [Lab 1.1: Storing Data](#lab-11-storing-data)
    - [Lab 1.2: Reading Data](#lab-12-reading-data)
      - [Question: CloudFormation Console](#question-cloudformation-console)
    - [Lab 1.3: Integration with CloudFormation](#lab-13-integration-with-cloudformation)
  - [Retrospective](#retrospective)
    - [Question 1](#question-1)
    - [Question 2](#question-2)
- [Further Reading](#further-reading)

<!-- /TOC -->

## Guidance

- Explore the official docs! See the the Topic Name
  [User Guide](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html),
  [API Reference](https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_GetParameters.html),
  [CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/ssm/index.html),
  and
  [CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ssm-parameter.html)
  docs.

- Avoid using other sites like stackoverflow.com for answers \-- part
  of the skill set you're building is finding answers straight from
  the source, AWS.

- Explore your curiosity. Try to understand why things work the way
  they do. Read more of the documentation than just what you need to
  find the answers.

## Lesson 1: Introduction to Topic Name

### Principle 1

*Parameter Store is a key-value store that is compelling and powerful in
its simplicity.*

### Practice 1

Let's start out by creating a few parameters and finding ways we can
read them. In the labs below, keep a few things in mind:

- Parameter Store keys are naturally split by `/` into a hierarchy (but
  [it's not necessary](https://aws.amazon.com/blogs/mt/organize-parameters-by-hierarchy-tags-or-amazon-cloudwatch-events-with-amazon-ec2-systems-manager-parameter-store/).
  You can use this to namespace your keys.

- Because we work in a shared account, namespacing is important.

- Parameter Store data is unique per region, but not per availability
  zone, and it would be easy to make your keys overlap with somebody
  else's if you're all working in the same region in the same time
  period.

- To establish a convention where we avoid overlapping with other's
  work, prefix your keys with
  `/*your-aws-username*/onboarding/lab11/`.

#### Lab 1.1: Storing Data

Using the data in [For The People](https://forthepeople.stelligent.com) as
inspiration, create a new CloudFormation stack that can store a handful
of data points for a Stelligent engineer in Parameter Store. Make it
generic, so that each data point is passed as a Stack parameter, as if
the stack template might be used to store info about each of our
engineers.

- Create a sub-tree of
  [AWS::SSM::Parameter](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ssm-parameter.html)
  resources that will store information on a single engineer.
- Every Parameter Store value type can be a string.
- At the top of the sub-tree, use a name for the engineer as your key
  value. See the [Name constraints](https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_PutParameter.html#systemsmanager-PutParameter-request-Name)
  in the PutParameter API docs for limitations. Try to enforce some
  of those limitations in your stack's [parameter properties](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html),
  too. (E.g. set an AllowedPattern and MaxLength. Can you set any
  other limitations?).
- Store all other keys under that.
- Store the engineer's customer/team name under "team".
- Store their timezone under "timezone".
- Store their home state as a 2-letter prefix under "state".
- Store their start date under "start-date".

Launch the stack with a parameter file that sets information for
yourself.

#### Lab 1.2: Reading Data

Look at ways to read your parameter data.

- You can look it up in the
  [console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Parameters:)

- You can read it with the API using
  [GetParameter](https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_GetParameter.html),
  [GetParameters](https://boto3.readthedocs.io/en/latest/reference/services/ssm.html#SSM.Client.get_parameters)
  and
  [GetParametersByPath](https://boto3.readthedocs.io/en/latest/reference/services/ssm.html#SSM.Client.get_parameters_by_path)

- You can invoke those same API queries through the
  [aws ssm](https://docs.aws.amazon.com/cli/latest/reference/ssm/index.html)
  CLI

Use all 3 methods to read your parameters individually and to fetch the
entire subtree with a single query.

##### Question: CloudFormation Console

_When you look at your stack in the CloudFormation console, can you find
the values of your parameter resources there?_

#### Lab 1.3: Integration with CloudFormation

CloudFormation can use Parameter Store keys and values as
[stack parameters](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html#aws-ssm-parameter-types).
This gives us an incredibly convenient way to maintain stack parameters
without the hassle of updating JSON files and keeping them in sync
through S3 or git repositories.

Make a copy of the original EC2 stack from the Load Balancing topic.
Instead of creating a web server with a page that says "Automation for
the People", make one that describes an engineer.

- One parameter should be an "AWS::SSM::Parameter::Name" that will
  reference the top-level key of your hierarchy as set in your stack
  from lab 1.

- Accept an "AWS::SSM::Parameter::Value" type for each of the Param
  Store values that you set in your stack from lab 1.

- Show the value of each of those stack parameters in the web page
  that nginx serves.

When you launch your stack, make sure the web page shows the values of
all the keys that you set in lab 1.

As follow-up to the question above about finding the values of your
parameter resources, take note of a comment in the SSM Parameter Types
document linked in the previous paragraph:

> You can see the resolved values for SSM parameters on the stack's
> Parameters tab in the console, or by running
> [describe-stacks](http://docs.aws.amazon.com/cli/latest/reference/cloudformation/describe-stacks.html)
> or
> [describe-change-set](http://docs.aws.amazon.com/cli/latest/reference/cloudformation/describe-change-set.html).
> These are the values that are currently used in the stack definition
> for the corresponding Systems Manager parameter keys. Note that these
> values are set when the stack is created or updated, so they might
> differ from the latest values in Parameter Store.

### Retrospective

...

#### Question 1

_Read [Using Dynamic References to Specify Template Values](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/dynamic-references.html).
Why can't you use that feature directly to read "middle-name" and show
it in your web page?_

#### Question 2

_Can you use Secure String as an `AWS::SSM::Parameter::Value` type in a
CloudFormation stack?_

## Further Reading

- Amazon recently [introduced](https://aws.amazon.com/blogs/aws/aws-secrets-manager-store-distribute-and-rotate-credentials-securely/)
  [Secrets Manager](https://aws.amazon.com/secrets-manager/). It
  integrates Parameter Store, Lambda, and a few other services into
  a product that makes password maintenance and rotation easier to do.
  Take a look at the [FAQ](https://aws.amazon.com/secrets-manager/faqs/)
  for a succinct summary of the service.

- [The Right Way to Store Secrets Using Parameter Store](https://aws.amazon.com/blogs/mt/the-right-way-to-store-secrets-using-parameter-store/),
  in the AWS Tools Blog, covers Parameter Store usage nicely, and
  introduces the IAM permissions that are required to managed it as well.
