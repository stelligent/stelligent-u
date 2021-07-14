# Topic 0: Development Environment

<!-- TOC -->

- [Topic 0: Development Environment](#topic-0-development-environment)
  - [Conventions](#conventions)
  - [Lesson 0.1: Setting up your development environment](#lesson-01-setting-up-your-development-environment)
    - [Principle 0.1](#principle-01)
    - [Practice 0.1](#practice-01)
      - [Lab 0.1.1: AWS Access Keys](#lab-011-aws-access-keys)
        - [Option 1: Getting Credentials via STS command](#option-1-getting-credentials-via-sts-command)
          - [Exercise 0.1.1: MFA Script](#exercise-011-mfa-script)
          - [Question 0.1.1: 1](#question-011-1)
          - [Question 0.1.1: 2](#question-011-2)
        - [Option 2: Using AWS Vault to automatically handle your temporary tokens](#option-2-using-aws-vault-to-automatically-handle-your-temporary-tokens)
      - [Lab 0.1.2: GitHub](#lab-012-github)
      - [Lab 0.1.3: Cloud9 Environment](#lab-013-cloud9-environment)
      - [Lab 0.1.4: Clone Repository](#lab-014-clone-repository)
    - [Retrospective 0.1](#retrospective-01)
      - [Question: Environments](#question-environments)
      - [Task](#task)

<!-- /TOC -->

## Conventions

- Do NOT store AWS credentials in code repositories.

  - [Managing access keys](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html)
  - [Configuration and credentials files](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html)

- DO use the Cloud9 environment for all training work unless otherwise specified.
- DO use the [AWS documentation and user guides](https://aws.amazon.com/documentation/).

## Lesson 0.1: Setting up your development environment

### Principle 0.1

_A reliable, repeatable process to create your development environment
leads to a solution others can contribute to._

The following labs will prepare you to work through the Stelligent
new hire training over the next 8 weeks. During the training you
will be using AWS access keys for programmatic access to an AWS account,
GitHub code repositories, and AWS Cloud9 for your development environment.

### Practice 0.1

#### Lab 0.1.1: AWS Access Keys

Add your AWS access key and secret key to your laptop. You
will need to [install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
and then run some simple commands to confirm access using your keys:

- [list-buckets](https://docs.aws.amazon.com/cli/latest/reference/s3api/list-buckets.html)
- [describe-instances](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html)

Remember that the combination of an access key and a secret key are
the same as user credentials and should not be given out or stored
in a public location like a GitHub repository, nor should they be
transmitted in an insecure manner like unencrypted email.
_Never_ commit credentials to a git repo.

- [Enable MFA](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html)
  for your AWS account. With MFA enabled you will need to generate temporary
  credentials using your MFA device and STS. You can do this in a few
  ways. The first way would be to request the token from STS via the CLI.

##### Option 1: Getting Credentials via STS command

> This was the method I was most familiar with, as I had created a console alias ages ago so I could generate temp creds for use in remote machines. This has the downside of exposing creds to the shell.

```shell
aws sts get-session-token \
    --serial-number arn:aws:iam::324320755747:mfa/USERNAME \
    --token-code 123456` \
/
```

This will return json containing the temporarily credentials.

```shell
"Credentials": {
    "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
    "SessionToken": "AQoDYXdzEJr...<remainder of security token>",
    "Expiration": "2018-10-11T10:09:50Z",
    "AccessKeyId": "ASIAIOSFODNN7EXAMPLE",
  }
}
```

Using these temporary credentials you will need to edit your `.aws/credentials`
file and change the security configuration for the profile to be used.

```shell
[temp]
output = json
region = us-east-1
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
aws_session_token = AQoDYXdzEJr...<remainder of security token>
```

Now set AWS_PROFILE to temp in your env, or set the --profile flag to temp when
running awscli. You should be able to access any of the resources you're
authorized to in the labs account. These tokens will last approximately
12 hours before needing to be reset using the process above.

###### Exercise 0.1.1: MFA Script

1. Create a script to automate the gathering and assigning of the temporary
   AWS MFA credentials from Option 1.

> This is a shell alias I used previously for this purpose.

```shell
alias gettempcreds=$(aws sts get-session-token --duration-seconds 129600 | jq -r '.Credentials | " export AWS_ACCESS_KEY_ID='\''" + .AccessKeyId + "'\'' AWS_SECRET_ACCESS_KEY='\''" + .SecretAccessKey + "'\'' AWS_SESSION_TOKEN='\''" + .SessionToken + "'\''"' | xsel -b)
```

> This was used on a linux system (xsel -b) to copy onto clipboard for paste into an SSH session.
> The output contains a leading space so it is not recorded in shell history.

1. Try to reduce the amount of manual input as much as possible.

> By setting the `mfa_serial` in the `~/.aws/config` I was able to use native prompts to achieve this goal.

###### Question 0.1.1: 1

What method did you use to store the aws credentials? What are some other
options?

> Previously, I would manage credentials as env vars in my `~/.zshrc`. As a result I couldn't commit this to a .dotfiles repo, but it gave me the ability to swap between creds by changing which variables are active for a given account.

> export AWS_ACCESS_KEY_ID=$IVL_AWS_ACCESS_KEY_ID

> export AWS_SECRET_ACCESS_KEY=$IVL_AWS_SECRET_ACCESS_KEY

> export IVL_AWS_ACCESS_KEY_ID='AKIA1234567890...S'

> export IVL_AWS_SECRET_ACCESS_KEY='f12345678901...w'

> This is a very manual process and much more cumbersome than the aws-vault stuff below.

###### Question 0.1.1: 2

Which AWS environment variable cannot be set in order to run the
`aws sts get-session-token` command?

> This seems like a trick question? The only one you can't know ahead of time is the MFA code, but TOTP codes last up to 60s, so that is long enough to set it and make a call quickly. If you haven't added MFA to your `~/.aws/config` than either of the AWS keys can be set in env and you can still call `aws sts get-session-token`.

##### Option 2: Using AWS Vault to automatically handle your temporary tokens

> I found a GUI version of this at https://github.com/Noovolari/leapp

If you would rather not have to manually get STS tokens and add them to your
credentials file you can use [aws-vault](https://github.com/99designs/aws-vault).

Configure the profile that you would like to use using this command:
`aws-vault add MY_PROFILE`

If you accidentally setup aws-vault with a password that you forgot,
you can remove its database (`rm -rf Library/Keychains/aws-vault.keychain-db`)
and start over.

To use aws-vault for temporary credential management is simple. You need to add
the arn of your mfa token to your profiles config in `~/.aws/config` like so:

```shell
[profile MY_PROFILE]
output = json
region = us-east-1
mfa_serial = arn:aws:iam::324320755747:mfa/USERNAME
```

Now you can execute any command using aws-vault. Example:
`aws-vault exec MY_PROFILE -- aws s3 ls`

You want to set an alias in your .bashrc or .zshrc to something like this:
`alias aws-myprofile="aws-vault exec MY_PROFILE -- aws"`

> As a shortcut, you can also add alias commands to `~/.aws/cli/alias`

```shell
[toplevel]
whoami = sts get-caller-identity --query Arn --output text
```
> This will allow me to use `aws whoami` in place of commands that ask for the owner-arn

#### Lab 0.1.2: GitHub

1. Create a new repository from the [Stelligent-U repository template](https://github.com/stelligent/stelligent-u/generate)
1. Select the owner of the repository
1. Name the new private repository
1. Generate ssh keys and
   test access. Use [this GitHub guide](https://help.github.com/articles/connecting-to-github-with-ssh/)
   to get access and clone the private repo to your laptop.

> I elected to fork the repo instead, which achieves the same result. I already have ssh keys on my github profile.

#### Lab 0.1.3: Cloud9 Environment

AWS Cloud 9 is a resource to quickly re-create a stock development
environment accessible from almost anywhere in a browser. You can use
the Cloud9 environment to work on the remainder of the Stelligent-U
labs, but it is not required.

Create a new Cloud 9 environment in the region of your preference
(ie: `us-east-1`) in the AWS account using the [AWS user guide](https://docs.aws.amazon.com/cloud9/latest/user-guide/welcome.html).
Be sure to note the different options when setting up the environment,
but use the default options for this lab. In Cloud9, run the same AWS
CLI commands as you did in [lab 0.1.1](#lab-011-aws-access-keys):

- `list-buckets`
- `describe-instances`

> `aws cloud9 create-environment-ec2 --name my-demo-env --description "My demonstration development environment." --instance-type t2.micro --subnet-id subnet-1fab8aEX --automatic-stop-time-minutes 60 --owner-arn arn:aws:iam::123456789012:user/MyDemoUser`

> In order to use this command we will first need to provide a value for `--subnet-id` so I will need to create a VPC.
> To do this I will first run the command:

VPC Creation: `aws ec2 create-vpc --cidr-block 10.0.0.0/16 --no-amazon-provided-ipv6-cidr-block --output yaml-stream`
> This returns the following YAML-Stream when we create the VPC

```yaml
- Vpc:
    CidrBlock: 10.0.0.0/16
    CidrBlockAssociationSet:
    - AssociationId: vpc-cidr-assoc-080a4924d43986cfb
      CidrBlock: 10.0.0.0/16
      CidrBlockState:
        State: associated
    DhcpOptionsId: dopt-0065f7d5d4ddc917a
    InstanceTenancy: default
    Ipv6CidrBlockAssociationSet: []
    IsDefault: false
    OwnerId: '324320755747'
    State: pending
    VpcId: vpc-0768b9b45373f3b83
```
> This returns the follwing YAML-Stream when we create the Subnet

Subnet Creation: `aws ec2 create-subnet --cidr-block 10.10.0.0/18 --availability-zone us-west-2a --vpc-id vpc-0768b9b45373f3b83 --output yaml-stream`

```yaml
- Subnet:
    AssignIpv6AddressOnCreation: false
    AvailabilityZone: us-west-2a
    AvailabilityZoneId: usw2-az1
    AvailableIpAddressCount: 251
    CidrBlock: 10.0.1.0/24
    DefaultForAz: false
    Ipv6CidrBlockAssociationSet: []
    MapPublicIpOnLaunch: false
    OwnerId: '324320755747'
    State: available
    SubnetArn: arn:aws:ec2:us-west-2:324320755747:subnet/subnet-081b02e0cb7082ca5
    SubnetId: subnet-081b02e0cb7082ca5
    VpcId: vpc-0768b9b45373f3b83
```
> Now that we have a subnet, we can create our cloud9 instance

`aws cloud9 create-environment-ec2 --description "demo dev env for Matthew Morgan" --name mcm-dev-env --instance-type t3.micro --automatic-stop-time-minutes 30 --owner-arn `aws whoami` --subnet-id subnet-081b02e0cb7082ca5`

> Which will return an Environment id like {"environmentId": "079d761679ee4236aeade608e1e2e4c1"}.

> From this point we can query our environments with `aws cloud9 describe-environments --environment-id 079d761679ee4236aeade608e1e2e4c1` which will return something like:
```yaml
- environments:
  - arn: arn:aws:cloud9:us-west-2:324320755747:environment:079d761679ee4236aeade608e1e2e4c1
    connectionType: CONNECT_SSH
    description: demo dev env for Matthew Morgan
    id: 079d761679ee4236aeade608e1e2e4c1
    lifecycle:
      status: CREATING
    managedCredentialsStatus: DISABLED_BY_DEFAULT
    name: mcm-dev-env
    ownerArn: arn:aws:iam::324320755747:user/matthew.morgan.labs
    type: ec2
```
> And we can connect to our ide by going to https://us-west-2.console.aws.amazon.com/cloud9/ide/{environmentId}

> Of course this is much harder than it needs to be. We could automate this futher using CloudFormation, Terraform, Ansible, etc.
> Example of a cloudformation Template for Cloud9 below:

```yaml
Parameters:
  EC2InstanceType:
    Default: t3.micro
    Description: EC2 instance type on which IDE runs
    Type: String
  AutoHibernateTimeout:
    Default: 30
    Description: How many minutes idle before shutting down the IDE
    Type: Number
  SubnetIdentifier:
    Description: SubnetId
    Type: AWS::EC2::Subnet::Id
Resources:
  IDE:
    Type: AWS::Cloud9::EnvironmentEC2
    Properties:
      Repositories:
      - RepositoryUrl: https://github.com/stelligent/mu-cloud9.git
        PathComponent: github.com/stelligent/mu-cloud9
      Description: Cloud9 IDE
      AutomaticStopTimeMinutes:
        Ref: AutoHibernateTimeout
      SubnetId:
        Ref: SubnetIdentifier
      InstanceType:
        Ref: EC2InstanceType
      Name:
        Ref: AWS::StackName
Outputs:
  Cloud9URL:
    Value:
      Fn::Join:
      - ''
      - - https://console.aws.amazon.com/cloud9/home/environments/
        - Ref: IDE
    Description: Cloud9 environment        
```
> If you have issues connecting to the environment, it's quite likely you created a private subnet without an igw- route, and thus cannot access your resources.

#### Lab 0.1.4: Clone Repository

Work with your GitHub repo in your Cloud9 development environment. Start
at [step 3 of this user guide](https://docs.aws.amazon.com/cloud9/latest/user-guide/sample-github.html#sample-github-install-git)
to configure the Cloud9 instance to work with GitHub.

1. Install git in Cloud9.

1. Clone the repository to your Cloud9 environment. To gain
   access to the repository try using either
   [token authentication](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
   or an [SSH key](https://help.github.com/articles/connecting-to-github-with-ssh/).

### Retrospective 0.1

#### Question: Environments

_Running the two commands in [lab 0.1.1](#lab-011-aws-access-keys) and
[lab 0.1.3](#lab-013-cloud9-environment) should have shown the same
results. What does this tell you about the access the keys give you on
your laptop and the access you have in the Cloud9 environment? What
other methods are there to provide this level of access without using
keys?_

#### Task

Configure Cloud9 to work with the programming language you will be using
to complete the training work. In your Cloud9 Editor, perform the following:

- Please choose either Ruby, Python, Go or NodeJS
- Create a new branch off master
- In the 00-dev-environment directory, develop a small "hello world!"
  application in that language
- Add the files to your new branch, commit them, and push the branch up to
  your forked repository
- Create a pull request from your branch to the master branch within your forked
  repository and merge after reviewing
