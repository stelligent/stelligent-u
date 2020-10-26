# Topic 14: Jenkins

<!-- TOC -->

- [Topic 14: Jenkins](#topic-14-jenkins)
  - [Guidance](#guidance)
  - [Lesson 14.1: Introduction to Jenkins](#lesson-141-introduction-to-jenkins)
    - [Principle 14.1](#principle-141)
    - [Practice 14.1](#practice-141)
      - [Lab 14.1.1: Installation with CloudFormation](#lab-1411-installation-with-cloudformation)
      - [Lab 14.1.2 - Adding Agents](#lab-1412---adding-agents)
      - [Lab 14.1.3 - Jenkins Native Tools](#lab-1413---jenkins-native-tools)
      - [Lab 14.1.4: Logging](#lab-1414-logging)
    - [Retrospective 14.1](#retrospective-141)
      - [Question: Agent Access](#question-agent-access)
      - [Question: Security](#question-security)
  - [Lesson 14.2: Plugins](#lesson-142-plugins)
    - [Principle 14.2](#principle-142)
    - [Practice 14.2](#practice-142)
      - [Lab 14.2.1 - Browsing Plugins](#lab-1421---browsing-plugins)
      - [Lab 14.2.2 - Automatic Plugin Management](#lab-1422---automatic-plugin-management)
    - [Retrospective 14.2](#retrospective-142)
      - [Question: Plugin Management](#question-plugin-management)
  - [Lesson 14.3: Pipelines](#lesson-143-pipelines)
    - [Principle 14.3](#principle-143)
    - [Practice 14.3](#practice-143)
      - [Lab 14.3.1: Writing a Pipeline](#lab-1431-writing-a-pipeline)
        - [Task: Artifact Storage](#task-artifact-storage)
        - [Task: Build Parameters](#task-build-parameters)
      - [Lab 14.3.2: Pipeline Reuse](#lab-1432-pipeline-reuse)
    - [Retrospective 14.3](#retrospective-143)
      - [Question: AWS Permissions](#question-aws-permissions)
      - [Question: Build Definition Management](#question-build-definition-management)
  - [Lesson 14.4: Backup](#lesson-144-backup)
    - [Principle 14.4](#principle-144)
    - [Practice 14.4](#practice-144)
      - [Lab 14.4.1: Backing up the Server](#lab-1441-backing-up-the-server)
    - [Retrospective 14.4](#retrospective-144)
      - [Question: Instance Backup](#question-instance-backup)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Guidance

- Do NOT copy and paste from the Internet at large
- DO use the [Jenkins documentation](https://jenkins.io)
- DO utilize the [Plugin index](https://plugins.jenkins.io/) to determine
  if there is a community provided solution available.
- Only specify the minimum configuration required for your Jenkins
  architecture and plugins. Don't get completely lost in all the options
  you can add.

## Lesson 14.1: Introduction to Jenkins

### Principle 14.1

*Jenkins is a leading open source automation server, providing thousands
of plugins to support building, deploying and automating any project.*

### Practice 14.1

Let's start off by [creating the Jenkins infrastructure](https://aws.amazon.com/getting-started/projects/setup-jenkins-build-server/).

#### Lab 14.1.1: Installation with CloudFormation

Jenkins, operating as a CI/CD server, can be hosted on-premise with a
dedicated machine or hosted [in the cloud](https://d1.awsstatic.com/Projects/P5505030/aws-project_Jenkins-build-server.pdf).
For ease of deployment and scalability, we will provision a Jenkins
environment using CloudFormation templates on the AWS platform. In order
to do this you will need the following:

- EC2 Instance (as the Jenkins Server) -- use the Amazon Linux AMI with JDK installed
  - EIP, for the instance to receive traffic
- Subnet, containing the Jenkins master instance
  - Route Table, for communication with users
  - Internet Gateway, allowing inbound and outbound traffic
- VPC, containing the subnet
- Security Group, to allow incoming WEB and SSH access **to your IP only**

You may work off of the provided `base.yaml` template.

Once you have created the CloudFormation template, launch it and navigate
to the Jenkins instance when complete. Finish the installation by
installing Jenkins on the EC2 instance, and starting the service. Finally,
following the admin install wizard by navigating to the instance IP at the
correct port. Verify that Jenkins is set up and ready for use by ensuring
the "Welcome to Jenkins!" prompt is present and you can:

- Add a "New Item"
- Browse "People"
- View "Build History"
- "Manage Jenkins"
- Manage "Credentials"
- View "My Views"

#### Lab 14.1.2 - Adding Agents

As it stands, the Jenkins server can be used to execute jobs. Executing jobs
in this manner, however, is not ideal due to scalability, management, or
performance. This is where agents come into play.

Jenkins uses the master-agent [distributed architecture](https://wiki.jenkins.io/display/JENKINS/Distributed+builds),
which makes the master server responsible for scheduling, dispatching,
monitoring, and history aggregation for jobs. The worker nodes meanwhile,
are responsible for fulfilling requests from the master with their
specialized configurations (OS, programs, tools, etc).

To take advantage of this architecture, we will update our CloudFormation
template to add these agents. Update the template to add the following
instances into your VPC:

- 1 EC2 T2 Small instance with the latest Ubuntu 18.04 AMI
- 1 EC2 T2 Micro instance with the latest Amazon Linux AMI
  (containing OpenJDK 8)

You may use a [Launch Template](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-launchtemplate.html)
to reduce redundant configurations. Also, make sure these instances can
communicate with the master Jenkins server:

- default 8080 inbound SG rule on Jenkins server (for handling requests)
- default 50000 inbound SG rule on Jenkins server (for JNLP)
- default 8080 outbound SG rule on Agent
- default 50000 outbound SG rule on Agent

Update the existing stack to add these new resources. By default, these
EC2 instance will not be capable of registering with the master server.
In order to do that, the agent service must be installed by retrieving
them from the master server, and then starting the service on the agent
instances.

To do this, the process would require 2 steps.

1. Creation of a new node from "Manage Jenkins" > "Manage Nodes"
1. Retrieval and starting of the agent java service
  (See ["Different ways of starting agents"](https://wiki.jenkins.io/display/JENKINS/Distributed+builds)
  section)

  _Note: An alternative method allowing agents to automatically discover
  and register with the master server is achieved using the [Swarm Plugin](https://wiki.jenkins.io/display/JENKINS/Swarm+Plugin)._

#### Lab 14.1.3 - Jenkins Native Tools

Now that Jenkins is configured in the proper manner, you may begin
exploring the facilities that it offers. Out of the box, it is pretty
basic but there are a few things you should be aware and why/when to
use them.

- [Script console](https://wiki.jenkins.io/display/JENKINS/Jenkins+Script+Console)
  for execution of commands on machines
- [Command line params](https://wiki.jenkins.io/display/JENKINS/Starting+and+Accessing+Jenkins)
  when running the Jenkins from the CLI
- [Administration](https://wiki.jenkins.io/display/JENKINS/Administering+Jenkins)
  overview
- [Remote access API](https://wiki.jenkins.io/display/JENKINS/Remote+access+API)
  submitting
- [Logging](https://wiki.jenkins.io/display/JENKINS/Logging)
- Plugins (discussed next)

#### Lab 14.1.4: Logging

Out of the box, Jenkins has no integrated way of forwarding logs to AWS.
One common way to do this the [Cloudwatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html).
Since all worker nodes logs are managed by the master server, the
Cloudwatch Agent only needs to be installed on the master server. With the
Cloudwatch Agent, storing log data in cloudwatch works in near-real time,
and can be extended with Cloudwatch metrics to send alarms in response to
certain events.

Going back to your CloudFormation template, extend it to install the
Cloudwatch Agent and monitor logs at `/var/log/jenkins/jenkins.log`

When you have finished, relaunch the CloudFormation template and check that
logs can be found inside Cloudwatch.

### Retrospective 14.1

#### Question: Agent Access

_Can you access the agent machine directly? Taking the distributed
architecture in account, is this preferable?_

#### Question: Security

_How secure is your Jenkins environment? What measures can be taken to
increase security from the Jenkins configuration side (*hint:*,
authentication & authorization)  as well as with the infrastructure
resources (*hint:* security groups, NACL, WAF, Inspector)?_

## Lesson 14.2: Plugins

### Principle 14.2

*There are thousands of Jenkins plugins to support building, deploying
and automating any project.*

### Practice 14.2

#### Lab 14.2.1 - Browsing Plugins

Plugins are a critical component of working with Jenkins since by default,
only basic functionality is available out-the-box. Depending on the
capabilities you need, it is best to check the available plugins. For
example, plugins are offered for features such as:

- Git integration
- Secure credential storage
- Matrix based security
- Backups
- Test report generation
- EC2 as agent support
- Improved Jenkins interface with Blue Ocean

Let's get familiar with what is offered by browsing the [plugin index](https://plugins.jenkins.io/).

After you have finished understanding the common categories of plugins,
add 2 plugins to the Jenkins server:

- 1 for git integration
- 1 for matrix based security

For the matrix based security plugin, add another jenkins user and have
them restricted to read only access.

#### Lab 14.2.2 - Automatic Plugin Management

Plugin installation is often a manual process where features are selected
as needed. There are several ways to introduce repeatability and
management of plugins, they include:

- [Jenkins client cli tool](https://jenkins.io/doc/book/managing/plugins/)
- [install-plugins.sh for Jenkins on Docker](https://github.com/jenkinsci/docker/blob/master/install-plugins.sh)
- [Ansible playbook](https://docs.ansible.com/ansible/latest/modules/jenkins_plugin_module.html)
- [Jenkins Configuration as Code (JCasC) Plugin](https://github.com/jenkinsci/configuration-as-code-plugin/)
  (Not recommended as not all plugins can be installed & configured -- many
  features are still in development)

Keep in mind that with plugins installation, there is a need to consider
version management. 'Latest' versions may break/deprecate existing
functionality, while older versions may contain security vulnerabilities.
Thus it is important to understand when/where that tradeoff should be made.

Explore the applicable plugin installation methods above and note the
limitations and tradeoffs of each one.

### Retrospective 14.2

#### Question: Plugin Management

_Considering the many options for plugin management, which makes the most
sense for our current Jenkins infrastructure?_

## Lesson 14.3: Pipelines

### Principle 14.3

*[A Pipeline is a user-defined model of a CD pipeline](https://jenkins.io/doc/book/pipeline/)*

### Practice 14.3

With a functional understanding of Jenkins, let's finally write a Pipeline
to perform work.

Pipelines can be written in 3 ways:

- [Scripted Pipeline Job](https://jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline)
  - This is the traditional manner for creating Pipelines. The syntax is
    strictly Groovy and allows for advanced control flows (loops, conditions, etc)
    not available in the Declarative syntax.
- [Declarative Pipeline Job](https://jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)
  - This is the newer standard for creating Pipelines. The aim in using
    the declarative style of writing pipelines, is for readability and
    ease of use.
- Freestyle Job
  - As the name suggests, allows freestyle (manual) creation of a
    workflow. There is no Jenkinsfile involved. This is a good way
    to get familiar with writing pipelines and there are
    [plugins capable of converting a freestyle job to a true Jenkins pipeline](https://jenkins.io/blog/2017/12/15/auto-convert-freestyle-jenkins-jobs-to-coded-pipeline/)

 In general we will use either the Declarative or Scripted syntax in a
 `Jenkinsfile`. In practice, it is common to see a mixed use of both
 syntax styles inside a Jenkinsfile -- and the differences between the
 2 are not substantial. That is, a pipeline will start off in the
 Declarative manner, and remain so until a need arises to perform some
 programmatic logic. The programmatic logic using scripted syntax will
 exist within a `script` block.

#### Lab 14.3.1: Writing a Pipeline

Using the ['Pipeline Syntax'](https://jenkins.io/doc/book/pipeline/syntax)
and the ['Using a Jenkinsfile'](https://jenkins.io/doc/book/pipeline/jenkinsfile/)
pages, create a pipeline using the Declarative syntax with 2 [stages](https://jenkins.io/doc/book/pipeline/syntax/#stages).

1. Git checkout of the master branch of your git forked repo (or another)
  _(use the Ubuntu instance as the agent to execute this stage)_
1. `mvn clean validate compile test package` of the root Java project source "`my-app`"
  _(use the Linux instance as the agent to execute this stage)_

Following the mvn execution, store the Java `target` artifacts as job
output.

After you have made the Jenkinsfile, ensure you have git configured in
Jenkins to start a build (using polling or hook) from your repo before
committing and pushing. When you are ready, commit and push.

Did your pipeline run as expected (It may take a minute depending on the
change detection configuration)? If not, you can manually trigger a scan
on your sources to start the pipeline build for projects with new changes
detected.

**Note:** *For debugging, it is possible to edit the Pipeline seen from the
last build using the job [Replay](https://jenkins.io/doc/book/pipeline/development/#replay)
feature. Doing so allows you ignore the Jenkinsfile in source control, and
use the edited one instead ([build parameters](https://wiki.jenkins.io/display/JENKINS/Parameterized+Build)
of the last build can not be changed however). Because users can execute
arbitrary code in place of the pipelines Jenkinsfile, it is recommended to
control use of this feature*

##### Task: Artifact Storage

After creating and running your pipeline were you able to access the build
artifacts? Storing build artifacts for a pipeline is an important step when
crafting workflows because build artifacts can be referenced in other
pipelines. Since they persist as long as the Jenkins server has them on disk,
it is important to archive them in a separate artifact manager (Artifactory,
S3, Nexus, npm, Ruby Gems, etc).

Because we have no way of accessing build artifacts from a build, edit the
Jenkinsfile to provide artifact upload capability to an S3 bucket using a
plugin.

##### Task: Build Parameters

When user defined data needs to be passed in to your job, build parameters
can be used, thus making the build a [Parameterized Build](https://wiki.jenkins.io/display/JENKINS/Parameterized+Build).
Default values can be used for the parameters and a variety of parameter
types can be passed, common ones include:

- Boolean
- Choice (single option)
- Credentials
- String
- File
- Password

Edit the Jenkinsfile to provide a String, Choice, and Boolean parameter
of your naming.

Call these in a new stage to verify you can act on these values.

#### Lab 14.3.2: Pipeline Reuse

In real world applications, teams will have their own Jenkinsfile
representing their CI/CD process. To follow this exercise, we will
manually create a new Freestyle job that mirrors the same steps
outlined in your Jenkinsfile pipeline. Although the steps are the same,
we will recognize the Freestyle job as belonging to team A. While our
Jenkinsfile is a pipeline belonging to team B.

If another team comes along and needs makes a pipeline, it is likely
that they will copy an existing Jenkinsfile, or manually create a
Freestyle job in the same manner. Depending on how the teams are managed,
this may become hard to maintain. To avoid this and allow common CI
functionality to be reused, we need to introduce a [Shared Library](https://jenkins.io/doc/book/pipeline/shared-libraries/).

A shared library can be available globally (to all Jenkins projects)
or at the project level. The shared library in essence consists of files
containing code which can be used (via imports) in Pipelines (`Jenkinsfile`).

Let's add a shared library to the your repo and configure Jenkins to point
to it.

In your shared repo define a method `mvnBuild.groovy` which echos
environment variable information using a simple command `env` and then
executes a java maven build with `mvn clean validate compile test`. The
method does not need to accept any string arguments.

Make this new function available as a global library (Manage Jenkins
Setting) and update your Jenkinsfile pipeline to call this function in
place of the existing `mvn` step.

Ensure this new method is called by reviewing the build logs for your job.

**Note:** Shared libraries are not only capable of encapsulating step level
code, but can even be be [used to execute multiple stage blocks -- and even
an entire pipeline](https://jenkins.io/blog/2017/10/02/pipeline-templates-with-shared-libraries/).
This makes it preferable to use when standardizing pipelines.

### Retrospective 14.3

#### Question: AWS Permissions

_What would happen if in your pipeline, you needed to run AWS specific
commands on an agent? Why wouldn't the commands work?_

#### Question: Build Definition Management

_Build definitions are typically stored in the same repository of the
project that will be built. When there are many projects, how could
management of the many build definitions be handled to provide for better
centralization and restricted control to a dedicated administration team?_

## Lesson 14.4: Backup

### Principle 14.4

*Anything that can go wrong will go wrong - Murphys Law.*

### Practice 14.4

#### Lab 14.4.1: Backing up the Server

Server failures must be accounted for when architecting Jenkins
infrastructure. Generally, there are 2 options for backup: Instance backup
and Volume backup. Because we are administering Jenkins from AWS, we will
focus on Instance backup -- Volume backups can be performed by enabling
the appropriate plugin and setting a backup schedule.

Ensure that your Jenkins master instance has been created and is EBS backed.

[Take a snapshot](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ebs-creating-snapshot.html)
of the  master instance volume containing configuration, history, logs
necessary to be restored.

Terminate the Jenkins master instance.

Instantiate a new Jenkins master instance but using the Jenkins EBS
snapshot you previously took and verify configuration, build history,
logs, plugins are there from before.

### Retrospective 14.4

#### Question: Instance Backup

_The benefits of using EBS for snapshots are that snapshots are
incremental, can be encrypted, and are stored in S3. It should be noted
that when snapshots are made on a running instance, cached data and
certain activities may be excluded if they occur after the time the
snapshot command was issued._

_How would you auto-schedule volume snapshots to periodically occur and
use the latest backup for recovery?_

## Further Reading

- [Jenkins Configuration as Code Plugin](https://github.com/jenkinsci/configuration-as-code-plugin):
  streamline jenkins provisioning using coded configuration
- [Multibranch Pipeline](https://jenkins.io/doc/book/pipeline/multibranch/):
  useful for executing pipelines defined in separate branches
- [Pipeline Access Authorization](https://jenkins.io/doc/book/system-administration/security/build-authorization/):
  control user access to pipelines
- [Parallel Stages](https://jenkins.io/blog/2018/07/02/whats-new-declarative-piepline-13x-sequential-stages/):
  beneficial for running concurrent processes to speed up build time
- [AWS Automation with Jenkins](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-jenkins.html):
  provides the ability to execute on-demand and scheduled tasks
- [Standard Security Options](https://wiki.jenkins.io/display/JENKINS/Standard+Security+Setup):
  for controlling access & privileges
