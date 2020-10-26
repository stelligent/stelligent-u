# Terraform

<!-- TOC -->

- [Terraform](#terraform)
  - [Guidance](#guidance)
  - [Lesson 17.1: Introduction to Terraform](#lesson-171-introduction-to-terraform)
    - [Principle 17.1](#principle-171)
    - [Prerequisites 17.1](#prerequisites-171)
      - [Lab 17.1.1 Terraform Language Features](#lab-1711-terraform-language-features)
        - [Types](#types)
        - [Built-in Functions](#built-in-functions)
        - [Other Important Language Features](#other-important-language-features)
      - [Lab 17.1.2 Terraform Resources, Data Sources, and Variables](#lab-1712-terraform-resources-data-sources-and-variables)
        - [Resources](#resources)
        - [Data Sources](#data-sources)
        - [Input Variables](#input-variables)
        - [Local Values](#local-values)
        - [Outputs](#outputs)
    - [Retrospective 17.1](#retrospective-171)
      - [Question: Default Minimum Module Files](#question-default-minimum-module-files)
  - [Lesson 17.2: Getting Started and Terraform State](#lesson-172-getting-started-and-terraform-state)
    - [Principle 17.2](#principle-172)
    - [Practice 17.2](#practice-172)
      - [Lab 17.2.1: Terraform Quickstart](#lab-1721-terraform-quickstart)
      - [Lab 17.2.2: Terraform State Management](#lab-1722-terraform-state-management)
        - [Question: State Management](#question-state-management)
        - [Question: Secrets](#question-secrets)
      - [Lab 17.2.3: Terraform State Lock](#lab-1723-terraform-state-lock)
        - [Question: State Issues](#question-state-issues)
    - [Retrospective 17.2](#retrospective-172)
      - [Question: Terraform State Security](#question-terraform-state-security)
  - [Lesson 17.3: Terraform Project Management](#lesson-173-terraform-project-management)
    - [Principle 17.3](#principle-173)
    - [Practice 17.3](#practice-173)
      - [Lab 17.3.1: Directory Structure and Workspaces to Separate Environments](#lab-1731-directory-structure-and-workspaces-to-separate-environments)
        - [Question: Workspaces](#question-workspaces)
      - [Lab 17.3.2 Better Use of Variables, Automation With Plan and Apply](#lab-1732-better-use-of-variables-automation-with-plan-and-apply)
        - [Question: CI/CD Pipelines](#question-cicd-pipelines)
      - [Lab 17.3.3: Further Network Changes](#lab-1733-further-network-changes)
    - [Retrospective 17.3](#retrospective-173)
      - [Question: View Terraform Plan File](#question-view-terraform-plan-file)
  - [Lesson 17.4: Using Terraform Modules](#lesson-174-using-terraform-modules)
    - [Principle 17.4](#principle-174)
    - [Practice 17.4](#practice-174)
      - [Lab 17.4.1: Creating and Using a Module](#lab-1741-creating-and-using-a-module)
      - [Lab 17.4.2: Module Versioning](#lab-1742-module-versioning)
    - [Retrospective 17.4](#retrospective-174)
      - [Question: When to Use Modules](#question-when-to-use-modules)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Guidance

- Explore the official docs! See the the Terraform [official docs](https://www.terraform.io/docs/index.html),
  and [AWS provider docs](https://www.terraform.io/docs/providers/aws/index.html).

- Avoid using other sites like stackoverflow.com for answers \-- part
  of the skill set you're building is finding answers straight from
  the Terraform docs.

- Explore your curiosity. Try to understand why things work the way
  they do. Read more of the documentation than just what you need to
  find the answers.

## Lesson 17.1: Introduction to Terraform

### Principle 17.1

[Terraform](https://www.terraform.io/) is an open-source tool for writing
infrastructure as code created and developed by
[HashiCorp](https://www.hashicorp.com/). It provides an alternative to AWS
CloudFormation for managing cloud resources, and through the use of various
_providers_, it is used to manage other vendors' resources as well. Terraform is
written using HashiCorp's HCL syntax, but exhaustive knowledge of HCL is not
necessary to [use Terraform effectively.](https://www.terraform.io/docs/configuration/syntax.html)

Terraform doesn't necessarily make it as easy to port infrastructure between
cloud providers as it may have a reputation for. Providers have different
products, and so rewriting code is necessary to move between, say, GCP and AWS.
But Terraform _does_ make it easy to share info between providers, and
definitely makes multi-cloud or a migration more manageable.

### Prerequisites 17.1

- Terraform [version 0.12.0 or later](https://www.terraform.io/downloads.html)

#### Lab 17.1.1 Terraform Language Features

We'll quickly go over some basic language features to help us get started...

##### Types

- primitive types
  - string
  - number (no separate type for int vs float)
  - bool
- complex (constructed) types - all members of collections must be the same type
  - list: zero-indexed ordered collection, accessed via `my_list[index_number]`
  - map: group of key-value pairs, access via `my_map["element_key"]`
  - set: non-indexed non-ordered collection, no literal syntax; call `toset` to
    convert a list to a set
- null type

See [the official
documentation](https://www.terraform.io/docs/configuration/expressions.html#types-and-values)
for more details on types.

##### Built-in Functions

There are [too many functions to go over in explicit
detail](https://www.terraform.io/docs/configuration/functions.html); most of
them do what you'd expect given their name. Give them a glance now anyway, and
come back when you need to reference them later. **Note:** Terraform only supports
these built-in functions; you cannot define your own.

##### Other Important Language Features

Terraform allows you to approximate loop-like behavior when creating resources
by using a `count` meta-argument in your resource blocks. `count` is fairly
limited, and the fact that it makes a _list_ (i.e. ordered collection) of
resources can lead to some unwanted behavior should a resource's index in the
list need to change.

In Terraform 0.12 there are two new expressions to help deal with `count`'s
limitations: You can use a `for` expression to simply loop over a list or map
(very similar to a Python list or dict comprehension); or you can use a `for_each`
meta-argument (similarly to `count`) to create a _map_ of resources (based off a
_map_ or _set_ of strings).

String interpolation is accomplished with `${}` syntax; for example:

```
"Hello ${var.world}"
```

#### Lab 17.1.2 Terraform Resources, Data Sources, and Variables

##### Resources

Terraform infrastructure is created through _resource_ elements, declared in
blocks as follows:

```
resource "aws_instance" "my_instance" {
  instance_type = "t2.micro"
  ami           = "ami-1234567890"
}
```

The combination of _resource type_ and _resource name_ must be unique; this
allows the resource to be referenced throughout your code. You can reference an
argument set in the resource configuration: `aws_instance.my_instance.ami`
would evaluate to `ami-1234567890"`. You can also reference attributes of the
resources you create (it is up to the provider to implement this):
`aws_instance.my_instance.id` would give you the instance id. See the provider
docs for a list of exported attributes for a resource type.

##### Data Sources

Terraform has a concept of a _data_ resource; declaring this won't create any
infrastructure, but will allow information to be read and referenced elsewhere
in your code. The arguments for this block are used as filters; it is often
required that one and only one resource match all the filters, and additionally
it must be an exact match.

```
data "aws_vpc" "my_vpc" {
  tags {
    Name        = "my-public-vpc"
    Environment = "production"
  }
}
```

Again, the combination of _resource type_ and _resource name_ must be unique. In
this case, you'd reference the vpc id using `data.aws_vpc.my_vpc.id`.

##### Input Variables

Terraform supports _input variables_ that need to be passed to your stack
(similar to parameters in CloudFormation); they're declared as follows:

```
variable "region" {
  default = "us-east-1"
  type    = string
}
```

This would be referenced as `var.region`. Note that "default" values for a
variable cannot themselves contain variables.

##### Local Values

You can declare "local" values in a terraform file/module, allowing you to make
your code more readable and easier to update:

```
locals {
  team = "Stelligent"
}
```

You'd reference this with `local.team`. It's a bit of a contrived example, but
it would probably be better to take a team name as a variable, and construct the
local from that:

```
variable "team_name" {
  default = "Stelligent"
  type    = string
}

locals {
  team = var.team_name
}
```

##### Outputs

When using _modules_, you can output values. We'll cover this in the modules labs.

### Retrospective 17.1

#### Question: Default Minimum Module Files

_What are the recommended files for a minimum Terraform module?_

## Lesson 17.2: Getting Started and Terraform State

### Principle 17.2

Terraform stores the state of your infrastructure project as a JSON file.
Terraform natively supports many methods of storing and managing your project's
state.

### Practice 17.2

#### Lab 17.2.1: Terraform Quickstart

Now we're going to quickly get a Terraform environment up and running. Some of
the actions we'll take won't have an immediate explanation, but we'll cover the
reasoning behind them later. For the moment, we just want to get working so that
we can be more hands-on.

- Create a directory named `state-management` (more on why shortly). In that
  directory, create a file named `main.tf` containing the following; feel free
  to replace the region with one of your choice. You'll need to specify the
  name of the AWS profile you'll be using, as well.

  ```
  provider "aws" {
    version = "~> 2.0"
    region  = "us-east-2"
    profile = "your-profile-name-here"
  }
  ```

As Terraform can be used to manage resources for vendors other than AWS, we're
specifying above that we intend to create AWS resources in this project. Should
we want to create resources for another vendor (or custom resources, etc.), we'd
need to create a provider block for them as well. With the above code, Terraform
will take care of installing the provider that will allow us to create and
configure AWS resources.

- Using the [AWS provider docs](https://www.terraform.io/docs/providers/aws/index.html)
  as a guide, write the code necessary to create an S3 bucket with versioning
  and encryption enabled, that allows only private access. Standard (not KMS)
  encryption is fine for now. Give this bucket a name indicating you're using
  it for a Stelligent-U CL module. (Do this in main.tf)

- From the `state-management` directory, run `terraform init` in order to
  prepare to create the bucket. Pay attention to what Terraform is doing.

- Terraform uses "workspaces" to isolate state for different environments; run
  `terraform workspace list` to see the available workspaces. It's not good
  practice to use the `default` workspace, so create a new one by running
  `terraform workspace new` with a workspace name of your choice as the final argument.

- Finally, run `terraform apply` to create the S3 bucket. Please note at this
  point Terraform will be making AWS API calls on your behalf, so you must
  have AWS credentials for the profile name you specified in `main.tf`.

- Prior to creating resources (or changing them), Terraform will list the
  actions it will take, and prompt you to confirm you wish to proceed.

Log in to the console and verify your bucket was created as expected.

#### Lab 17.2.2: Terraform State Management

In contrast to CloudFormation, Terraform stores project state in a file that you
can inspect, edit, and reference in other projects. Accordingly, you're required
to manage this state. Terraform allows you to do this in several ways, and in
this lab we'll examine a couple of them, settling on a method that is standard
best practice.

As part of the commands we ran above, Terraform created some subdirectories.
One of these is `terraform.tfstate.d/<workspace-name>/`, and it now contains
a statefile (`terraform.tfstate`). Examine this file - it's just JSON, which is
often convenient. This _local state_ is the default way Terraform manages state;
we must configure Terraform to use another method to manage state.

While it's fine for a project spike with a single engineer, it's generally
not good practice to manage state locally or even in a git repository;
this can lead to problems when multiple engineers are working on the project,
or should someone forget to commit the latest state to version control. So
we'll configure Terraform to use the S3 bucket we just created to house our
infrastructure state. This is known as _remote state_.

- Paste the following code at the beginning of `main.tf`, substituting values
  where necessary:

  ```
  terraform {
    backend "s3" {
      bucket  = "<bucket-name-you-chose-previously>"
      key     = "state_management/terraform.tfstate"
      encrypt = true
      region  = "<region-the-bucket-is-in>"
      profile = "<profile-if-you-specified-one>"
    }
  }
  ```

This configures Terraform to use our S3 bucket to store state. This is why we
enabled versioning and encryption when creating the S3 bucket - versioning is
very useful should our project's statefile get deleted somehow, and encryption
is important as the statefile is simply JSON. We still have the problem of any
secrets having only S3 standard encryption (i.e. not KMS), but it's better than
before and can be somewhat managed via IAM.

- Run `terraform init` again - this will cause Terraform to pick up the change
  in configuration. Terraform will pick up that we've changed our state
  management method, and ask if we want to move the statefile to our S3
  bucket. Answer "yes" when you're prompted to do so.

- Examine the local statefile. It should be empty. There should also be a
  backup statefile. Examine the backup.

- Confirm the new state is stored in your S3 bucket. Examine this file; what
  differences are there between this one and the backup you have locally?

##### Question: State Management

_While it's good we're now managing state remotely, can you think of any
problems we might run into with our current state management setup?_

##### Question: Secrets

_Storing secrets in Terraform state is an ongoing issue. Can you think of
a better solution than the basic AES256 encryption we've used in these
labs so far?_

#### Lab 17.2.3: Terraform State Lock

Remote state solves much of the problem of state getting out of sync, and some
of the problem of multiple users making changes to a project, but there is still
significant risk should multiple users (or even the same user!) attempt to apply
changes simultaneously. To help manage this risk, Terraform supports _state
locking_, which ensures only one set of changes is applied to a project at
a time. In this lab, we'll create the necessary infrastructure to support state
lock, and reconfigure our project to use state lock.

- With the AWS provider docs as a reference, create a DynamoDB table with a
  string attribute of "LockID"; use this attribute as the hash key.

- Run `terraform apply` to create the DynamoDB table.

- Modify the `terraform` block in `main.tf` to include the line
  `dynamodb_table = <name-you-chose-for-the-table>`.

- Run `terraform init` yet again.

Terraform is now configured to lock the project state when making changes; if
unable to obtain a state lock (after a configurable timeout), Terraform will not
make the changes. While the resource creation and changes we've made thus far
are fairly quick, you should take the opportunity to observe the state actually
being locked in later portions of this module.

##### Question: State Issues

_Do you think using Terraform to bootstrap and manage its own state
infrastructure is a problem? Why or why not?_

### Retrospective 17.2

#### Question: Terraform State Security

_Is any sensitive data stored in the Terraform state file? If so, what
steps should you take to ensure the file is secure?_

## Lesson 17.3: Terraform Project Management

### Principle 17.3

There are several ways to manage environments using Terraform; we'll examine
using Terraform's native workspaces to help with this. First, though, we'll look
at one way to structure your project's repo to aid in management.

### Practice 17.3

#### Lab 17.3.1: Directory Structure and Workspaces to Separate Environments

We all agree it's generally a very good idea to isolate your infrastructure
environments - we'd prefer that development environment infra changes didn't
bring down a production environment. But if our environment data is all stored
in a single state file, we're as tightly coupled as can be. One answer to this
is to keep multiple environments in a single repo, simply using directory
structure to separate project state. Additionally, we'd like to keep our network
infra separate from, say, our ec2 instances. We'll use directory structure to
accomplish this as well.

- In the root of our project (one directory above the `state-management`
  directory we created earlier), create two more directories - `dev` and `prod`.
  In each of these directories, create a `network-infra` directory.

- Again using the [AWS Provider
  Docs](https://www.terraform.io/docs/providers/aws/index.html), write the code
  necessary to create a vpc with two subnets (let's keep them private for now).
  Put this code in another `main.tf` file, in the `dev/network-infra` directory.

- Declare variables for the VPC CIDR and for the availability zones in which to
  house your subnets; go ahead for now and just define the variable where you're
  declaring it. If you like, use either `count` or `for_each` to
  automatically generate your desired number (in this case 2) of subnets.
  `count` is fairly trivial in this case, look up the documentation if you need.
  `for_each` will be somewhat more difficult. If you go the `for_each` route,
  you may need to create a map variable that associates an AZ with a
  pseudo-index (just a number). If you get stuck for too long, just use `count`
  for now.

- Try to use the [`cidrsubnet`
  function](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html)
  to automatically calculate the CIDRs for the subnets you create.

- You'll need to configure Terraform to again use S3 for the backend. Copy the
  `terraform` and `provider` blocks from `main.tf` in the `state-management`
  directory. Change the `key` in the `terraform` block to be something
  different, say `dev/network-infra/state/terraform.tfstate`.

- Run `terraform init` again, switch to a new (non-default) workspace, and run
  `terraform plan` (or just `terraform apply`, as you'll be prompted).

- After creation is successful, switch to yet another new workspace, update your
  CIDR variable, and run `terraform apply` again.

Congratulations, you've now spun up 2 (essentially) identical VPCs, separated by
Terraform's workspaces. Take a moment to look at your S3 state bucket - you
should see an `env:` folder, in which subdirectories for both of your new
workspaces live.

So, we now have infrastructure environments separated by directory structure
(i.e. our state management environment vs our dev network environments), as
well as environments separated strictly by workspace (both of our dev network
environments).

##### Question: Workspaces

_Are workspaces alone sufficient to separate dev environments from prod
environments? Why or why not?_

#### Lab 17.3.2 Better Use of Variables, Automation With Plan and Apply

Infrastructure tends to grow over time, and we could follow better practice than
throwing all of our code in `main.tf`. Let's split our declared variables out.

- Copy any existing variables into a file called `variables.tf`. Run `terraform
  plan` to ensure nothing is set to change.

- Let's ensure that our VPCs don't have overlapping CIDRs. Create a
  `<workspace-name>.tfvars` file, and define unique CIDRs in each of them. Note
  that you don't have to specify an item as a variable in a `.tfvars` file. So
  if you wrote:

  ```
  variable "vpc_cidr" {
    type = string
  }
  ```

  You would put it in the `.tfvars` file as:

  ```
  vpc_cidr = "10.0.0.0/20" # or whatever you have, of course
  ```

Let's start to automate changes a little more. `terraform plan` lets us
preview what API calls Terraform is going to make on our behalf. But there's
no strict guarantee that those are the calls that will be made; the state lock
is released after a plan, and infrastructure can (and at some point will)
change between running a `plan` and `apply`.

To help get around this risk, terraform lets us _output_ a plan to be executed
when we run `terraform plan -out <plan_file_name>`. That specific plan (set of
API calls) can then be executed with `terraform apply <plan_file_name>`

In your favorite language, write a build script that:

- Takes a workspace name and either `plan` or `apply` as an argument.

- Check for the existence of the `<workspace-name>.tfvars` file, and warn if it
  does not exist.

- Have the `plan` option save a plan file and notify the user the execution plan
  is available for review.

- Have the apply stage look for a waiting plan file, apply it if it exists, and
  exit with an error if it does not.

- Have an executed plan file archived in some way, with an approximate
  execution time recorded as well.

Run a plan, make some innocuous changes (add a tag?), save your work, then apply
the previously-saved plan file. Verify the newest (after-plan) changes were not
applied. Make a change, run a plan on a different workspace, apply the plan on
that workspace, and verify your currently selected workspace wasn't affected.

While this obviously isn't robust enough for a full production environment, it
at least begins to demonstrate _some_ of the care and safeguards that can be
taken to ensure we know what our IaC tool is going to do.

That brings up something that's very important to note: Terraform does not
automatically roll back on errors. If you have extensive CloudFormation
experience, hear it again: _Terraform does not automatically roll back on errors_.

##### Question: CI/CD Pipelines

_Consider how you would use a CI/CD pipeline to roll out infrastructure
changes. Outside of the pipeline itself, what additional resources would
you need to write/create?_

#### Lab 17.3.3: Further Network Changes

Let's make one (or both, your choice) of our subnets public. Edit the code to
include the necessary resources for a subnet to be public [referring to the
docs](https://www.terraform.io/docs/providers/aws/r/vpc.html) as necessary.

- Be sure to add any variables you need to the `variables.tf` file, and include
  them in any `.tfvars` files you've created as well.

- Once you're happy with the way your code works, clean up your dev network
  environments with `terraform destroy`.

### Retrospective 17.3

#### Question: View Terraform Plan File

_How do you view the contents of an output Terraform plan file without
applying it?_

## Lesson 17.4: Using Terraform Modules

### Principle 17.4

Terraform Modules are a way to create reusable and repeatable pieces of
infrastructure code; they can help engineers edit code in fewer places, speed up
development (nobody wants to write code for a VPC all the time), and ensure
consistency across environments.

### Practice 17.4

#### Lab 17.4.1: Creating and Using a Module

So, we now have some code we can use on-demand to create a VPC with at least one
public subnet. A general answer to the question "should I turn this code into a
module?" is "Yes, if the code provides an additional layer of abstraction." You
almost certainly wouldn't want to make a module for a single ec2 instance, for
example. But a VPC, public subnets, and the associated infra is a perfectly fine
abstraction layer, and so is a good candidate to be made into a module.

- Create a `modules` directory in the root of our project; create a
  `vpc_with_public_subnets` directory within the modules directory. Copy the
  `main.tf` and `variables.tf` files we've already written to the
  `vpc_with_public_subnets` directory.

- Let's provide some outputs about the resources this module creates. Create an
  `outputs.tf` file, and define outputs for the VPC id and the subnet ids. For
  example:

  ```
  output "vpc_id" {
    value = aws_vpc.my_vpc.id # assuming you've named your vpc "my_vpc"
  }
  ```

- The `output` format for the vpc ids will depend largely on how you've created
  them in your template. If you used `for_each`, it will use a `for` statement
  and look similar to this:

  ```
  output "public_subnet_ids" {
    value = [for az, s in aws_subnet.public_subnets : s.id]
  }
  ```

- In the `prod/network-infra` directory, create a `main.tf` file; you'll again
  need to fill out the `terraform` and aws `provider` blocks as before.

- Create a `variables.tf` file in the directory, and populate it with the
  necessary information your network stack needs. Alternatively, use your build
  script and the `.tfvars` file.

- Create a `module` block in `main.tf`; you'll need to specify a name for the
  module (`my_vpc` will do fine), and need to use a local/relative path to point
  towards the module code.

- Once again, from the `prod/network` directory, run `terraform plan` and
  `terraform apply`.

Note: to access your module outputs in other modules, you'd use
`module.<module-name>.<output-name>`.

#### Lab 17.4.2: Module Versioning

Using modules can save a lot of time, but they can also introduce some concerns.
You're introducing code that you may not control into your infrastructure; even
outside the possibility of some mistake on the author's part, a module isn't
guaranteed to never need new input variables or to continue outputting the same
values. How can we ensure our infra is being built with the code we expect?

One way is to use a [module
registry](https://www.terraform.io/docs/registry/index.html) - HashiCorp runs
one with many open-source modules available to developers; organizations can run
[their own registry](https://www.terraform.io/docs/registry/private.html) as
well.

Another way is to use git refs when specifying the location of the module:

```
# Github
source = "github.com/stelligent/my-module?ref=v1.2.3"

# generic git repository
source = "git::https://some-module-source.com/my-module.git?ref=my-testing-branch"
```

To access a module nested within a source, use a `//` to indicate that the path
that follows is not part of the repo address:

```
source = "git::https://some-other-source.com/lots-of-modules.git//modules/vpc?ref=v4.5.6"
```

This does not work when loading local code; the module version that will be
checked out is the one that is checked out in your local repo.

You may also specify an S3 URL to check out a zipped module.

- If you're on a fork, commit your module and tag it. Make a small change (again
  perhaps a tag), specify the tagged ref for the module in your `main.tf`, and
  confirm the new change won't be deployed when running `terraform apply`.

- Congratulations, we're done! Remember to clean up after yourself - delete
  everything including the state configuration.

### Retrospective 17.4

#### Question: When to Use Modules

_What are some use cases and when is it appropriate to create a module?_

## Further Reading

[Terraform: Up & Running](https://www.terraformupandrunning.com/) - a fantastic
and comprehensive resource. It's worth a piece of your monthly budget.

[Gruntwork Blog](https://blog.gruntwork.io/) - Engaging and informative articles
from a team who are Terraform experts.

[Terratest](https://terratest.gruntwork.io/) - Testing for Terraform.

[Terraform Remote State as a Data
Source](https://www.terraform.io/docs/providers/terraform/d/remote_state.html) -
it is incredibly useful to be able to access other stack's outputs; this is
possible cross-region and even cross-provider.
