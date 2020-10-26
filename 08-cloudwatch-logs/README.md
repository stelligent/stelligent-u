# Topic 8: CloudWatch

<!-- TOC -->

- [Topic 8: CloudWatch](#topic-8-cloudwatch)
  - [Conventions](#conventions)
  - [Lesson 8.1: CloudWatch Logs storage and retrieval](#lesson-81-cloudwatch-logs-storage-and-retrieval)
    - [Principle 8.1](#principle-81)
    - [Practice 8.1](#practice-81)
      - [Lab 8.1.1: Log groups and streams](#lab-811-log-groups-and-streams)
      - [Lab 8.1.2: The CloudWatch agent](#lab-812-the-cloudwatch-agent)
      - [Lab 8.1.3: 3rd party tool awslogs](#lab-813-3rd-party-tool-awslogs)
      - [Lab 8.1.4: CloudWatch logs lifecycle](#lab-814-cloudwatch-logs-lifecycle)
      - [Lab 8.1.5: Clean up](#lab-815-clean-up)
    - [Retrospective 8.1](#retrospective-81)
  - [Lesson 8.2: CloudWatch Logs with CloudTrail events](#lesson-82-cloudwatch-logs-with-cloudtrail-events)
    - [Principle 8.2](#principle-82)
    - [Practice 8.2](#practice-82)
      - [Lab 8.2.1: CloudWatch and CloudTrail resources](#lab-821-cloudwatch-and-cloudtrail-resources)
      - [Lab 8.2.2: Logging AWS infrastructure changes](#lab-822-logging-aws-infrastructure-changes)
      - [Lab 8.2.3: Clean up](#lab-823-clean-up)
    - [Retrospective 8.2](#retrospective-82)
      - [Question](#question)
      - [Task](#task)

<!-- /TOC -->

## Conventions

- DO review CloudFormation documentation to see if a property is
  required when creating a resource.

## Lesson 8.1: CloudWatch Logs storage and retrieval

### Principle 8.1

CloudWatch Logs are the best way to securely and reliably store text
logs from application services and AWS resources (EC2, Lambda,
CodePipeline, etc) over time.

### Practice 8.1

This section shows you how to configure CloudWatch to monitor and store
logs for AWS resources, as well as how to retrieve and review those logs
using the AWS CLI and a utility called "awslogs".

#### Lab 8.1.1: Log groups and streams

A log group is an arbitrary collection of similar logs, using whatever
definition of "similar" you want. A log stream is a uniquely
identifiable flow of data into that group. Use the AWS CLI to create a
log group and log stream:

- Name the log group based on your username: *first.last*.c9logs

- Name the log stream named c9.training in your log group.

When you're done, list the log groups and the log streams to confirm
they exist.

#### Lab 8.1.2: The CloudWatch agent

The CloudWatch agent is the standard tool for sending log data to
CloudWatch Logs. We've provided a stack template for you in your *clone*
of the
[stelligent-u](https://github.com/stelligent/stelligent-u)
repo:

- [Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-first-instance.html)
  for installing the Cloud Watch agent. This is handled in the template, but
  in case it is needed for reference

- We need to generate a template file to be used when running.
  [Documentation on generating the template file](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html)
  The template file is quite complex, so the use of the wizard is recommended, and
  then editing the template file. In order to run the wizard, we need to have a
  running instance. Recommend launching the stack, running the wizard and then copying
  the generated file to S3 to be referenced in the template.

- Recommend not using `collectd` as it can cause the agent to fail to start

- Modify the template mappings to reference your own VPC ID's and Subnet ID in your
  account that you will launch resources into

- Modify the template so that the S3 config file is copied to the EC2 instance during
  the CloudFormation Init

- Modify the template so that the following run command references the config file:

  ```shell
  /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s
  ```

- Delete the running stack, and relaunch

- Use the AWS CLI to display the log events for your group and stream.

> *Note:* logs may take several minutes to appear.

#### Lab 8.1.3: 3rd party tool awslogs

[awslogs](https://github.com/jorgebastida/awslogs) is a
publicly-available Python tool that you can use to read CloudWatch logs.
It's especially convenient for tailing the log streams, showing you data
as it arrives.

- Install the awslogs client on your running EC2 instance.

- Use it to watch logs as they are put into your log group.

- Use awslogs to get logs from your group from the last 5 minutes,
  last 20 minutes and last hour.

#### Lab 8.1.4: CloudWatch logs lifecycle

Any time you're logging information, it's important to consider the
lifecycle of the logs.

- Use the AWS CLI to [set the retention policy](https://docs.aws.amazon.com/cli/latest/reference/logs/put-retention-policy.htm)
  of your log group to 60 days.

- Use the CLI to review the policy in your log group.

- Set the retention policy to the maximum allowed time, and review the
  change again to double-check.

#### Lab 8.1.5: Clean up

You can tear down your EC2 stack at this point.

Use the AWS CLI to remove the log group and log stream you created
earlier.

You'll need [jorgebastida/awslogs](https://github.com/jorgebastida/awslogs)
in Lesson 8.2.1, so now's a good time to install it on your laptop. You may
find that it's handy for client engagements and future lab work as well.

### Retrospective 8.1

*Log retention is an important issue that can affect many parts of a
company's business. It's helpful to know what CloudWatch Log's service
limitations are.*

- What are the minimum and maximum retention times?

- Instead of keeping data in CW Logs forever, can you do anything else
  with them? What might a useful lifecycle for logs look like?

## Lesson 8.2: CloudWatch Logs with CloudTrail events

### Principle 8.2

*CloudWatch Logs let you monitor AWS API changes via CloudTrail logged
events.*

### Practice 8.2

This section demonstrates CloudWatch's ability to send alerts based on
changes to AWS resources made via the API changes, identified through
CloudTrail events. This is useful for many reasons. For example, you may
want to understand what changes are being made to AWS resources and
decide if they are appropriate. Notifications or automated corrective
action can be configured when inappropriate changes are being made.

#### Lab 8.2.1: CloudWatch and CloudTrail resources

Let's switch from the awscli to CloudFormation. Create a template that
provides the following in a single stack:

- A new CloudWatch Logs log group

- An S3 bucket for CloudTrail to publish logs.

- A CloudTrail trail that uses the CloudWatch log group.

#### Lab 8.2.2: Logging AWS infrastructure changes

Now that you have your logging infrastructure, create a separate stack
for the resources that will use it:

- Create an S3 bucket or any other AWS resource of your choice.

- Add tags that mark it with your AWS username, and identify it as a
  stelligent-u resource with this topic and lab number.

- Use awslogs client utility to review the logs from the new group.
  You should see the activity from creating and changing the
  resource.

- Delete the CloudFormation stack and resources.

- Use the awslogs utility again to view those changes.

#### Lab 8.2.3: Clean up

- Delete any stacks that you made for this topic.

- Make sure you keep all of the CloudFormation templates from this
  lesson in your GitHub repo.

### Retrospective 8.2

#### Question

_What type of events might be important to track in an AWS account? If
you were automating mitigating actions for the events, what might they
be and what AWS resource(s) would you use?_

#### Task

Dig out the CloudFormation template you used to create the CloudTrail
trail in lab 8.2.1. Add a CloudWatch event, SNS topic and SNS
subscription that will email you when any changes to EC2 instances are
made. Test this mechanism by creating and modifying new EC2 instances.
Make sure to clean up the CloudFormation stacks and any other resources
when you are done.
