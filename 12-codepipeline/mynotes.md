# Create a codepipeline with cloudformation

Pre-req of the project

- Ec2 Instance and Postgresql db have been provisioned

## Project aim

- Use cloudformation to provision a codepipeline that will automate the build, test and deploy process of our app release

### Steps

- Create Ec2 Instance Role

  - InstanceRole
    Type: AWS::IAM::Role
    Properties:
    AssumeRolePolicyDocument:
    Statement: - Effect: Allow
    Principal:
    Service: - ec2.amazonaws.com
    Action: - sts:AssumeRole
    Path: /

  - InstanceRolePolicies
    Type: AWS::IAM::Policy
    Properties:
    PolicyName: InstanceRole
    PolicyDocument:
    Statement: - Effect: Allow
    Action: - autoscaling:Describe* - cloudformation:Describe* - cloudformation:GetTemplate - s3:Get*
    Resource: '*'
    Roles: - !Ref 'InstanceRole'

    - InstanceRoleInstanceProfile:
      Type: AWS::IAM::InstanceProfile
      Properties:
      Path: /
      Roles: - !Ref 'InstanceRole'

  - These instanceprofile gives ec2 instance permission to get codedeploy agent from s3
  - attach the IamInstanceProfile to the ec2 instance
    WebAppInstance:
    Properties:
    ...
    IamInstanceProfile: !Ref 'InstanceRoleInstanceProfile'

- INSTALL CODEDEPLOY AGENT

  - the codedeploy agent will be installed on each ec2 instances you want to deploy your app to and helps codedeploy communicate with your ec2 instances for deployments. first you will include the metadata in the AWS::CloudFormation::Init key, which will be used by the cfn-init helper script.

  WebAppInstance:
  ...
  Metadata:
  AWS::CloudFormation::Init:
  services:
  sysvint:
  codedeploy-agent:
  enabled: 'true'
  ensureRunning: 'true'

  - then we will add the UserData key, which allows us to pass user data to the ec2 instance to perform automated configuration tasks and run scripts after the instance starts up

  WebAppInstance:
  Properties:
  ...
  UserData: !Base64
  Fn::Join: - '' - - "#!/bin/bash -ex\n" - "yum update -y aws-cfn-bootstrap\n" - "yum install -y aws-cli\n" - "yum install -y ruby\n" - "iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000\n" - "echo 'iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000' >> /etc/rc.local\n" - "# Helper function.\n" - "function error_exit\n" - "{\n" - ' /opt/aws/bin/cfn-signal -e 1 -r "$1" ''' - !Ref 'WaitHandle' - "'\n" - " exit 1\n" - "}\n" - "# Install the AWS CodeDeploy Agent.\n" - "cd /home/ec2-user/\n" - "aws s3 cp 's3://aws-codedeploy-us-east-1/latest/codedeploy-agent.noarch.rpm'\
   \ . || error_exit 'Failed to download AWS CodeDeploy Agent.'\n" - "yum -y install codedeploy-agent.noarch.rpm || error_exit 'Failed to\
   \ install AWS CodeDeploy Agent.' \n" - '/opt/aws/bin/cfn-init -s ' - !Ref 'AWS::StackId' - ' -r WebAppInstance --region ' - !Ref 'AWS::Region' - " || error_exit 'Failed to run cfn-init.'\n" - "# All is well, so signal success.\n" - /opt/aws/bin/cfn-signal -e 0 -r "AWS CodeDeploy Agent setup complete."
  ' - !Ref 'WaitHandle' - "'\n"

  - add the waithandle resource
    WaitHandle:
    Type: AWS::CloudFormation::WaitConditionHandle
    WaitCondition:
    Type: AWS::CloudFormation::WaitCondition
    Properties:
    Handle: !Ref 'WaitHandle'
    Timeout: '900'

  - Next lets tag ec2 instances. Codedeploy will use these tags to identify which instances to deploy to
    WebAppInstance:
    Properties:
    ...
    Tags: - Key: 'CodeDeployTag'
    Value: 'CodeDeployDemo'

  - Now we have setup iam permissions for ec2 tp communicate with codedeploy and s3, and we have installed codedeploy agent on ec2 instances and also added tags for codeploy on all ec2 instances

- CREATE CODDEDEPLOY TRUST ROLE

  - This will give codedeploy access to ec2 instances
    CodeDeployTrustRole:
    Type: AWS::IAM::Role
    Properties:
    AssumeRolePolicyDocument:
    Statement: - Sid: '1'
    Effect: Allow
    Principal:
    Service: - codedeploy.us-east-1.amazonaws.com - codedeploy.us-west-2.amazonaws.com
    Action: sts:AssumeRole
    Path: /
    CodeDeployRolePolicies:
    Type: AWS::IAM::Policy
    Properties:
    PolicyName: CodeDeployPolicy
    PolicyDocument:
    Statement: - Effect: Allow
    Resource: - '_'
    Action: - ec2:Describe_ - Effect: Allow
    Resource: - '\*'
    Action: - autoscaling:CompleteLifecycleAction - autoscaling:DeleteLifecycleHook - autoscaling:DescribeLifecycleHooks - autoscaling:DescribeAutoScalingGroups - autoscaling:PutLifecycleHook - autoscaling:RecordLifecycleActionHeartbeat
    Roles: - !Ref 'CodeDeployTrustRole'

  Outputs:
  ...
  CodeDeployTrustRoleARN:
  Value: !GetAtt 'CodeDeployTrustRole.Arn'

  - create this stack by updating the stack from part 2(stack of ec2 instances and db instance)

- CREATE CODEPIPELINE PIPELINE

  - the pipeline we are building will have 3 stages:

    - a source stage to pull our code from the github repo. the source stage will use a codestarconnection and an s3 bucket

    - a build stage to build the source code into an artifact. The build stage will use a codebuild project and the same s3 bucket

    - a deploy stage to deploy the artifact to the ec2 instance. The deploy stage will use a codedeploy app and a codedeploy deploymentgroup

  - PREPARE THE APP TO DEPLOY

    - sample app: [hello-express-app](https://github.com/jennapederson/hello-express) forked into my github account.

    - for the purpose of this demo, the most interesting parts are the ffg:

      - buildspec.yaml:
        is a spec file that contains build commands and configurations that are used to build a codebuild project

      - appspec.yaml
        is a spec file that defines a series of lifecycle hooks for a codedeploy deployment

      - bin directory(storing scripts)
        contains the www start script for the app, and the scripts for each of the lifecycle hooks.

    - ADD PARAMETERS
      Parameters:
      GitHubRepo:
      Type: String

      GitHubBranch:
      Type: String
      Default: main

      GitHubUser:
      Type: String

      CodeDeployServiceRole:
      Type: String
      Description: A service role ARN granting CodeDeploy permission to make calls to EC2 instances with CodeDeploy agent installed.

      TagKey:
      Description: The EC2 tag key that identifies this as a target for deployments.
      Type: String
      Default: CodeDeployTag
      AllowedPattern: '[\x20-\x7E]\*'
      ConstraintDescription: Can contain only ASCII characters.

      TagValue:
      Description: The EC2 tag value that identifies this as a target for deployments.
      Type: String
      Default: CodeDeployDemo
      AllowedPattern: '[\x20-\x7E]\*'
      ConstraintDescription: Can contain only ASCII characters.

- CREATE SERVICE ROLES

  - In order for codebuild to access s3 to put the artifact into the bucket, we will need to create a service role: CodeBuildServiceRole

  - we also need a service role to allow codepipeline to get the source code from the github connection, to start builds, to get the artifact from bucjet and to create and deploy the app: CodePipelineServiceRole

  CodeBuildServiceRole:
  Type: AWS::IAM::Role
  Properties:
  Path: /
  AssumeRolePolicyDocument:
  Version: 2012-10-17
  Statement: - Effect: Allow
  Principal:
  Service: codebuild.amazonaws.com
  Action: sts:AssumeRole
  Policies: - PolicyName: "logs"
  PolicyDocument:
  Version: "2012-10-17"
  Statement: -
  Effect: "Allow"
  Action: - logs:CreateLogGroup - logs:CreateLogStream - logs:PutLogEvents - ecr:GetAuthorizationToken - ssm:GetParameters
  Resource: "_" - PolicyName: "S3"
  PolicyDocument:
  Version: "2012-10-17"
  Statement: -
  Effect: "Allow"
  Action: - s3:GetObject - s3:PutObject - s3:GetObjectVersion
  Resource: !Sub arn:aws:s3:::${ArtifactBucket}/_

  CodePipelineServiceRole:
  Type: AWS::IAM::Role
  Properties:
  Path: /
  AssumeRolePolicyDocument:
  Version: 2012-10-17
  Statement: - Effect: Allow
  Principal:
  Service: codepipeline.amazonaws.com
  Action: sts:AssumeRole
  Policies: - PolicyName: root
  PolicyDocument:
  Version: 2012-10-17
  Statement: - Resource: - !Sub arn:aws:s3:::${ArtifactBucket}/*
                  - !Sub arn:aws:s3:::${ArtifactBucket}
  Effect: Allow
  Action: - s3:_ - Resource: "_"
  Effect: Allow
  Action: - codebuild:StartBuild - codebuild:BatchGetBuilds - iam:PassRole - Resource: - !Ref CodeStarConnection
  Effect: Allow
  Action: - codestar-connections:UseConnection - Resource: "\*"
  Effect: Allow
  Action: - codedeploy:CreateDeployment - codedeploy:CreateDeploymentGroup - codedeploy:GetApplication - codedeploy:GetApplicationRevision - codedeploy:GetDeployment - codedeploy:GetDeploymentConfig - codedeploy:RegisterApplicationRevision

- CREATE THE SOURCE STAGE
  For the source stage, we will create a codestar connection and an s3 bucket.

  - create a ccodestarconnection
    when we set up the pipeline, we will have a source stage that pulls our source code from github. To do this, we will need to create a codestarconnection for github. This will give our pipeline access to a github repo. we will use cloudformation to create this by adding the resource to our template, but there will be a manual step to change the connection from pending to available after the first time we apply the template

  CodeStarConnection:
  Type: 'AWS::CodeStarConnections::Connection'
  Properties:
  ConnectionName: CfnExamplesGitHubConnection
  ProviderType: GitHub

- CREATE THE S3 BUCKET
  ArtifactBucket:
  Type: AWS::S3::Bucket
  DeletionPolicy: Delete

- CREATE THE STAGE
  fIRST stage of the pipeline: source stage
  Pipeline:
  Type: AWS::CodePipeline::Pipeline
  Properties:
  RoleArn: !GetAtt CodePipelineServiceRole.Arn
  ArtifactStore:
  Type: S3
  Location: !Ref ArtifactBucket
  Stages: - Name: Source
  Actions: - Name: App
  ActionTypeId:
  Category: Source
  Owner: AWS
  Version: '1'
  Provider: CodeStarSourceConnection
  Configuration:
  ConnectionArn: !Ref CodeStarConnection
  BranchName: !Ref GitHubBranch
  FullRepositoryId: !Sub ${GitHubUser}/${GitHubRepo}
  OutputArtifacts: - Name: AppArtifact
  RunOrder: 1

        - Name: Build
          Actions:
            - Name: Build
              ActionTypeId:
                Category: Build
                Owner: AWS
                Version: '1'
                Provider: CodeBuild
              Configuration:
                ProjectName: !Ref CodeBuildProject
              InputArtifacts:
                - Name: AppArtifact
              OutputArtifacts:
                - Name: BuildOutput
              RunOrder: 1

        - Name: Deploy
          Actions:
            - Name: Deploy
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Version: '1'
                Provider: CodeDeploy
              Configuration:
                ApplicationName: !Ref CodeDeployApplication
                DeploymentGroupName: !Ref CodeDeployGroup
              InputArtifacts:
                - Name: BuildOutput
              RunOrder: 1

- create the build stage
  For the build stage, we will create a codebuild project that indicates what kind of environment to build the code in. Here we are using a docker container. we will also set the service role to the service role we created vbefore

  CodeBuildProject:
  Type: AWS::CodeBuild::Project
  Properties:
  Artifacts:
  Type: CODEPIPELINE
  Source:
  Type: CODEPIPELINE
  BuildSpec: buildspec.yml
  Environment:
  ComputeType: BUILD_GENERAL1_SMALL
  Image: aws/codebuild/docker:17.09.0
  Type: LINUX_CONTAINER
  Name: !Ref AWS::StackName
  ServiceRole: !Ref CodeBuildServiceRole

- CREATE THE DEPLOY STAGE
  we will need a codedeploy app and a codedeploy deployment group
  CodeDeployApplication:
  Type: AWS::CodeDeploy::Application

  CodeDeployGroup:
  Type: AWS::CodeDeploy::DeploymentGroup
  Properties:
  ApplicationName: !Ref CodeDeployApplication
  Ec2TagFilters: - Key: !Ref 'TagKey'
  Value: !Ref 'TagValue'
  Type: KEY_AND_VALUE
  ServiceRoleArn: !Ref 'CodeDeployServiceRole'

- ADD OUTPUTS

  Outputs:
  PipelineUrl:
  Value: !Sub https://console.aws.amazon.com/codepipeline/home?region=${AWS::Region}
