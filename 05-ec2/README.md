# Topic 5: Elastic Compute Cloud (EC2)

<!-- TOC -->

- [Topic 5: Elastic Compute Cloud (EC2)](#topic-5-elastic-compute-cloud-ec2)
  - [Conventions](#conventions)
  - [Lesson 5.1: Introduction to Elastic Compute Cloud](#lesson-51-introduction-to-elastic-compute-cloud)
    - [Principle 5.1](#principle-51)
    - [Practice 5.1](#practice-51)
      - [Lab 5.1.1: Cloud9's Instance Metadata](#lab-511-cloud9s-instance-metadata)
      - [Lab 5.1.2: Launch Two EC2 Instances](#lab-512-launch-two-ec2-instances)
      - [Lab 5.1.3: Update Your Stack](#lab-513-update-your-stack)
      - [Lab 5.1.4: Teardown](#lab-514-teardown)
    - [Retrospective 5.1](#retrospective-51)
      - [Task: Automating AMI Discovery](#task-automating-ami-discovery)
      - [Question: Resource Replacement](#question-resource-replacement)
  - [Lesson 5.2: Instance Access](#lesson-52-instance-access)
    - [Principle 5.2](#principle-52)
    - [Practice 5.2](#practice-52)
      - [Lab 5.2.1: Elastic IP](#lab-521-elastic-ip)
      - [Lab 5.2.2: SSH Keys](#lab-522-ssh-keys)
    - [Retrospective 5.2](#retrospective-52)
  - [Lesson 5.3: Monitoring EC2 Instances](#lesson-53-monitoring-ec2-instances)
    - [Principle 5.3](#principle-53)
    - [Practice 5.3](#practice-53)
      - [Lab 5.3.1: Understanding Instance Metrics](#lab-531-understanding-instance-metrics)
      - [Lab 5.3.2: Installing the CloudWatch Agent](#lab-532-installing-the-cloudwatch-agent)
        - [Task: Private Subnet](#task-private-subnet)
      - [Lab 5.3.3: cfn-init](#lab-533-cfn-init)
    - [Retrospective 5.3](#retrospective-53)
      - [Task: Cleaner Userdata](#task-cleaner-userdata)
      - [Task: Know When It Worked](#task-know-when-it-worked)
  - [Lesson 5.4: Exploring EC2 Instance Components](#lesson-54-exploring-ec2-instance-components)
    - [Principle 5.4](#principle-54)
    - [Practice 5.4](#practice-54)
      - [Lab 5.4.1: EBS Volumes](#lab-541-ebs-volumes)
      - [Lab 5.4.2: EBS Snapshot](#lab-542-ebs-snapshot)
      - [Lab 5.4.3: Attaching Snapshots](#lab-543-attaching-snapshots)
      - [Lab 5.4.4: Instance Snapshots](#lab-544-instance-snapshots)
      - [Lab 5.4.5: Clean Up](#lab-545-clean-up)
    - [Retrospective 5.4](#retrospective-54)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Conventions

- Do NOT copy and paste CloudFormation templates from the Internet at
  large

- DO use the [CloudFormation documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)

- DO utilize every link in this document; note how the AWS
  documentation is laid out

- DO use the [AWS CLI for CloudFormation](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/index.html#)
  (NOT the Console) unless otherwise specified.

- Only specify the minimum configuration required for your resources.
  Don't get completely lost in all the options you can add.

## Lesson 5.1: Introduction to Elastic Compute Cloud

### Principle 5.1

*EC2 is one of the fundamental building blocks of AWS.*

### Practice 5.1

Like IAM, EC2 consists of a set of services and resources. The majority
of those are focused around Instances, which initially was the smallest
unit of virtual compute capability in AWS. When combined, these
resources provide flexible compute and storage capacity, add support to
networking services, and provide snapshot capabilities supporting
virtual server consistency.

Of note:

- EC2-related services are the gateway for most clients into AWS

- EC2-related services are used to host container-based clusters via
  Elastic Kubernetes Service (EKS) and Elastic Container Service
  (ECS)

- Cloud9 uses instances to provide development environments

#### Lab 5.1.1: Cloud9's Instance Metadata

EC2 services are the engine behind your Cloud9 development environment.
Describe these instance attributes by querying the Cloud9 environment's
[instance metadata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html#instancedata-data-retrieval):

- the image snapshot, or Amazon Machine Image (AMI), the instance was
  launched from

- the Type of instance created from that AMI

- the public IPV4 IP address

- the Security Groups the instance is associated with

- the networking Subnet ID the instance was launched into

Save your queries (but not the outputs) in your source code.

#### Lab 5.1.2: Launch Two EC2 Instances

Create a CFN template that launches a simple EC2 instance when the stack
is created:

- Use a Launch Template resource
  [AWS::EC2::LaunchTemplate](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-launchtemplate.html)
  in your CFN scripts instead of including all the instance's
  attributes in the Instance resource

- Create two EC2 instance resources using that same Launch Template

  - One instance should use a Windows AMI for Microsoft Windows Server
    2016 Base
  - The other instance should be the AMI for Ubuntu 16.04 LTS

- Launch the instances into the default VPC

Create the stack:

- Write a script that uses the AWS CLI to launch the Stack and immediate
  employs a [waiter](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/wait/index.html)
  so that the script exits only when the CFN service has finished creating the
  stack.

- Use the AWS CLI to describe the stack's resources, then use the AWS
  CLI to describe each instance that was created.

#### Lab 5.1.3: Update Your Stack

Change the AMI ID for the Windows instance to instead launch an AMI for
Windows Server 2012 R2:

- Update your Stack.

- Query the stack's events using the AWS CLI. What happened to your
  original EC2 Windows instance?

#### Lab 5.1.4: Teardown

There is usually some delay between initiating an instance's termination
and the instance being considered eliminated altogether.

- Delete your Stack. Immediately after initiating Stack deletion, see
  if you can query your instance states.

### Retrospective 5.1

#### Task: Automating AMI Discovery

In lab 2, how did you find the AMI IDs required to launch the instances
in your target region? If you did *not use* a scripted mechanism, go
back and change your lab's code and repeat that lab: parameterize the
CFN template to accept both Linux and Windows AMI IDs, and provide the
values via a scripted mechanism.

#### Question: Resource Replacement

_When updating a Stack containing an EC2 instance,
[what other changes](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-update-behaviors.html)
will cause the same thing to occur as in Lab 5.1.3?_

## Lesson 5.2: Instance Access

### Principle 5.2

*EC2 Instances are the workhorses of AWS.*

### Practice 5.2

It is important for the rest of the topic to know how to connect to
your EC2 instance. Let's continue with your existing CFN template.

#### Lab 5.2.1: Elastic IP

Creating an Elastic IP (EIP) address allows your account to reserve a
static IP address. Applying this to an instance enables you to reach
that instance via that IP address. In the event of that instance's
failure, migrating the EIP to a replacement instance means processes
dependent on services available at that IP address can continue to
function.

- Remove your Windows instance from the CFN template. We will be
  working with just the Ubuntu 16 instance.

- Update the CFN template to create an EIP and associate that EIP with
  your Ubuntu instance.

- Create a CFN Output from the newly-created EIP's IPV4 address.

- Update the Stack.

- Using the AWS CLI, retrieve the Stack's outputs to fetch the EIP's
  IPV4 address.

Try pinging that IP address. Does it work?

- Using the CFN template, create a Security Group enabling
  [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol).

- Attach the security group to your Launch Template.

- Recreate the Stack.

Can you ping your instance now? If not, troubleshoot and fix the issue
using your CFN template.

#### Lab 5.2.2: SSH Keys

Being able to log into your instance using Secure Shell (SSH) is
generally... a security vulnerability. Nonetheless, during the
development of provisioning scripts and protocols, it is useful to be
able to SSH into the instance to debug and troubleshoot issues.

- Use the AWS CLI to generate an [AWS SSH Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).
  Store the private key locally in your development instance's .ssh
  folder.

  - When generating a keypair on the CLI, the private key is returned as a
  single string with newline characters embedded in it. To easily get the RSA
  string into a properly formatted private key file, you can do the following:
  `echo -e "rsa blob" > ./path/to/privatekey.pem`

- Update the CFN template to apply the new Key Pair to your Launch
  Template.

- Recreate the Stack.

Can you SSH into the instance?

- Update the CFN template to modify the ICMP-enabling Security Group,
  enabling SSH ingress on Port 22 from your IP and update the stack.

Now can you SSH into your instance? If not, troubleshoot and fix the
issue using your CFN template.

### Retrospective 5.2

For more information on resolving connection issues, see the
[Troubleshooting Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/TroubleshootingInstancesConnecting.html)

## Lesson 5.3: Monitoring EC2 Instances

### Principle 5.3

*Monitoring your AWS instances is critical for maintaining healthy workloads
in AWS EC2.*

### Practice 5.3

Monitoring is an important part of maintaining the reliability, availability,
and performance of your EC2 instances.

#### Lab 5.3.1: Understanding Instance Metrics

Continue with your CFN template that has an Ubuntu instance and SSH.
Read and re-read
[this entire section](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitoring_ec2.html)
of the AWS documentation. In AWS, our goal is generally to replace
servers that are malfunctioning due to the ease with which virtual
servers can be automated, but that makes monitoring the health of those
servers no less important. You can also watch
[these videos on Linux Academy](https://linuxacademy.com/cp/modules/view/id/163)
on EC2 monitoring.

A small number of metrics are collected for every EC2 instance, but installing
the [CloudWatch Agent on instances provides an extended set of metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html).

- Continue using the stack from Principal 1.

  - Make sure you are launching the instance into the default VPC
    for your region.

- Update the Stack if you needed to make any changes.

- Use the AWS Console to fetch and record the default instance metrics.

#### Lab 5.3.2: Installing the CloudWatch Agent

Let's [install the CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)
on that same Ubuntu instance using two more important features of EC2 Instance
provisioning: instance profiles and userdata.
[Instance profiles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html)
allow the instance to assume a role and utilize that role's privileges
to perform actions on AWS. [Userdata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
gives you the ability to run commands on the instance being launched. If
you get stuck SSH into the machine and use the logs referenced in the
Userdata docs to debug.

- Modify your CFN template so that your Launch Template installs and
  starts the CloudWatch Agent on boot-up of your Ubuntu 16.04 LTS
  Instance.

  - Is it necessary to [apply monitoring scripts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html)
    to send data to CloudWatch?

- Create a new role that trusts the EC2 Service to assume it, and that
  has the privileges to perform whatever actions are necessary to
  provide the additional metrics to CloudWatch.

- Create a corresponding instance profile and apply it to your Launch
  Template.

- Make sure a public IP is assigned to your instance

- Recreate your stack so [UserData will execute](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts)

Compare those same metrics with the values received from Lab 5.3.1.
Record your results.

##### Task: Private Subnet

The default VPC has only public subnets that you launched into. Copy
your template and add a new private subnet and launch your instance into
this private subnet. Add any other services you need to be able to send
metrics to CloudWatch from the instance in the private subnet.

#### Lab 5.3.3: cfn-init

User data itself is immensely useful for provisioning instances as
they're being instantiated, but maintaining long scripts detailing a
series of complex actions can be messy. One way to improve on the
organization of those provisioning directives is to use a combination of
the Metadata attribute and the [cfn-init capability](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html).

- Modify your CFN template again with the public subnet. Add
  [Metadata](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/metadata-section-structure.html)
  on your Instance, and migrate the logic that installs and starts
  the CloudWatch Agent into the Init (AWS::CloudFormation::Init)
  section.

- Recreate your stack

Verify that the metrics you expect to see (based on Lab 5.2.2) are still being collected.

### Retrospective 5.3

#### Task: Cleaner Userdata

With YAML's multi-line string syntax, you can embed userdata scripts
that don't require line "\\n", escapes and other syntactical mess that
makes the script difficult to read, debug, and reuse. If you haven't
done this already, try it and repeat Lab 5.2.3.

> Hint: when you want to put a bunch of commands into UserData in a
> YAML template, use this format to keep it readable:

```
UserData:
  Fn::Base64: !Sub |
    # bash code goes here just like a normal script.
    echo "Running in region ${AWS::Region}".
    env | sort
```

#### Task: Know When It Worked

Besides seeing evidence that the cfn-init processes worked, you can
combine the use of that with
[cfn-signal](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-signal.html)
to validate the success of your installation procedures. Add that
capability to your CFN template.

## Lesson 5.4: Exploring EC2 Instance Components

### Principle 5.4

*Instances are constructed from other independently manageable AWS components.*

### Practice 5.4

An EC2 Instance is like its own ecosystem. Hydrated from an Amazon
Machine Image (AMI) and configured to be specific to different types of
workloads, Instances can also take on a service role, be assigned a
static IP address or network interface, and be governed via logon access
controls and port and protocol limitations.

Let's continue with your existing CFN stack.

#### Lab 5.4.1: EBS Volumes

Add an additional Elastic Block Store (EBS) volume to your instance.

- Using CloudFormation, create a new EBS Volume (AWS::EC2::Volume) and
  attach it to your instance.

- Modify either the Userdata or cfn-init process to mount the new
  volume and make it available for use.

- Recreate your stack

SSH into the instance to verify your volume is mounted.

#### Lab 5.4.2: EBS Snapshot

Create a file on the new (secondary) EBS Volume, and take an EBS
snapshot.

- Using CloudFormation, update the Userdata or cfn-init process to
  write a simple text file to the new EBS Volume.

- Recreate the Stack.

- Once the instance has been updated, use the AWS CLI to create an EBS
  Snapshot of that same volume.

Use the AWS CLI to describe the newly-created EBS Snapshot. Save the output.

#### Lab 5.4.3: Attaching Snapshots

Repeat Lab 5.4.1, but modify the EBS volume to utilize the EBS Snapshot ID
as its source. This approach allows a failed instance to be rehydrated
using a recent snapshot, reducing or avoiding Volume data loss.

- Add a CFN Parameter to pass the Snapshot ID to the template.

- Modify the CFN template so that the secondary EBS Volume is derived
  from the Snapshot ID value from the Parameter.

- Update the Stack.

SSH into the instance. _Can you find the file that you wrote to your
secondary ESB Volume?_

#### Lab 5.4.4: Instance Snapshots

In addition to EBS Volumes, you can take a snapshot of an entire
Instance in the form on an Amazon Machine Image (AMI).

- SSH into your instance and add a file to your home directory.

- Using the AWS CLI, create an AMI from the instance.

- Update your CFN template and apply the new AMI to the EC2 Instance.

- Update the stack.

SSH into the new instance. Verify you see that home directory file in
the new instance.

#### Lab 5.4.5: Clean Up

Tear down this lesson's resources by deleting your stack. Have you made
resource manually for testing or discovery? Delete those, too.

### Retrospective 5.4

Read the [EBS Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html)
and the [Instance Store Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html)
to learn more about these components.

## Further Reading

- Instance types vary radically to support various types of cloud
  workloads. Become familiar with the [various types of instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html)
  and recognize that these change over time.

- Instance types shouldn't be confused with [instance purchasing options](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-purchasing-options.html).
  Read more about on-demand, reserved and spot instances as well as
  dedicated instances and dedicated hosts.
