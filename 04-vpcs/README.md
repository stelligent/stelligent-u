# Topic 4: Virtual Private Clouds (VPCs)

<!-- TOC -->

- [Topic 4: Virtual Private Clouds (VPCs)](#topic-4-virtual-private-clouds-vpcs)
  - [Lesson 4.1: Creating Your Own VPC](#lesson-41-creating-your-own-vpc)
    - [Principle 4.1](#principle-41)
    - [Practice 4.1](#practice-41)
      - [Lab 4.1.1: New VPC with "Private" Subnet](#lab-411-new-vpc-with-private-subnet)
      - [Lab 4.1.2: Internet Gateway](#lab-412-internet-gateway)
      - [Lab 4.1.3: EC2 Key Pair](#lab-413-ec2-key-pair)
      - [Lab 4.1.4: Test Instance](#lab-414-test-instance)
        - [Question: Post Launch](#question-post-launch)
        - [Question: Verify Connectivity](#question-verify-connectivity)
      - [Lab 4.1.5: Security Group](#lab-415-security-group)
        - [Question: Connectivity](#question-connectivity)
      - [Lab 4.1.6: Elastic IP](#lab-416-elastic-ip)
        - [Question: Ping](#question-ping)
        - [Question: SSH](#question-ssh)
        - [Question: Traffic](#question-traffic)
      - [Lab 4.1.7: NAT Gateway](#lab-417-nat-gateway)
        - [Question: Access](#question-access)
        - [Question: Egress](#question-egress)
        - [Question: Deleting the Gateway](#question-deleting-the-gateway)
        - [Question: Recreating the Gateway](#question-recreating-the-gateway)
      - [Lab 4.1.8: Network ACL](#lab-418-network-acl)
        - [Question: EC2 Connection](#question-ec2-connection)
    - [Retrospective 4.1](#retrospective-41)
  - [Lesson 4.2: Integration with VPCs](#lesson-42-integration-with-vpcs)
    - [Principle 4.2](#principle-42)
    - [Practice 4.2](#practice-42)
      - [Lab 4.2.1: VPC Peering](#lab-421-vpc-peering)
      - [Lab 4.2.2: EC2 across VPCs](#lab-422-ec2-across-vpcs)
        - [Question: Public to Private](#question-public-to-private)
        - [Question: Private to Public](#question-private-to-public)
      - [Lab 4.2.3: VPC Endpoint Gateway to S3](#lab-423-vpc-endpoint-gateway-to-s3)
    - [Retrospective 4.2](#retrospective-42)
      - [Question: Corporate Networks](#question-corporate-networks)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Lesson 4.1: Creating Your Own VPC

### Principle 4.1

*VPCs provide isolated environments for running all of your AWS
services. Non-default VPCs are a critical component of any safe
architecture.*

### Practice 4.1

This section walks you through the steps to create a new VPC. On every
engagement, you'll be working in VPCs created by us or the client. Never
use EC2 Classic or the default VPC.

This is a complicated set of labs. If you get stuck, take a look at the
example template in the
[AWS::EC2::VPCPeering](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpcpeeringconnection.html)
doc. It gives you a lot of info, but you can use it to see how resources
are tied together. The AWS docs also provide a
[VPC template sample](https://s3.amazonaws.com/cloudformation-templates-us-east-1/vpc_single_instance_in_subnet.template)
that may be useful.

#### Lab 4.1.1: New VPC with "Private" Subnet

Launch a new VPC via your AWS account, specifying a region that will be
used throughout these lessons.

- Use a [CloudFormation YAML template](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html).

- Assign it a /16 CIDR block in [private IP space](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#VPC_Sizing),
  and provide that block as a stack parameter in a [[separate parameters.json
  file]](https://aws.amazon.com/blogs/devops/passing-parameters-to-cloudformation-stacks-with-the-aws-cli-and-powershell).

- Create an EC2 subnet resource within your CIDR block that has a /24
  netmask.

- Provide the VPC ID and subnet ID as stack outputs.

- Tag all your new resources with:

  - the key "user" and your AWS user name;
  - "stelligent-u-lesson" and this lesson number;
  - "stelligent-u-lab" and this lab number.

- Don't use dedicated tenancy (it's needlessly expensive).

#### Lab 4.1.2: Internet Gateway

Update your template to allow traffic [to and from instances](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
on your "private" subnet.

- Add an Internet gateway
  [resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-internetgateway.html).

- Attach the gateway to your VPC.

- Create a route table for the VPC, add the gateway to it, attach it
  to your subnet.

We can't call your subnet "private" any more. Now that it has an
Internet Gateway, it can get traffic directly from the public Internet.

#### Lab 4.1.3: EC2 Key Pair

[Create an EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)
that you'll use to ssh to a test instance created in later labs. Use the
AWS CLI.

- Save the output as a .pem file in your project directory.

- Be sure to create it in the same region you'll be doing your labs.

#### Lab 4.1.4: Test Instance

Launch an EC2 instance into your VPC.

- Create another CFN template that specifies an EC2 instance.

- For the subnet and VPC, reference the outputs from your VPC stack.

- Use the latest Amazon Linux AMI.

- Create a new parameter file for this template. Include the EC2 AMI
  ID, a T2 instance type, and the name of your key pair.

- Provide the instance ID and private IP address as stack outputs.

- Use the same tags you put on your VPC.

##### Question: Post Launch

_After you launch your new stack, can you ssh to the instance?_

##### Question: Verify Connectivity

_Is there a way that you can verify Internet connectivity from the instance
without ssh'ing to it?_

#### Lab 4.1.5: Security Group

Add a security group to your EC2 stack:

- Allow ICMP (for ping) and ssh traffic into your instance.

##### Question: Connectivity

_Can you ssh to your instance yet?_

#### Lab 4.1.6: Elastic IP

Add an Elastic IP to your EC2 stack:

- Attach it to your EC2 resource.

- Provide the public IP as a stack output.

Your EC2 was already on a network with an IGW, and now we've fully
exposed it to the Internet by giving it a public IP address that's
reachable from anywhere outside your VPC.

##### Question: Ping

_Can you ping your instance now?_

##### Question: SSH

_Can you ssh into your instance now?_

##### Question: Traffic

_If you can ssh, can you send any traffic (e.g. curl) out to the Internet?_

At this point, you've made your public EC2 instance an [ssh bastion](https://docs.aws.amazon.com/quickstart/latest/linux-bastion/architecture.html).
We'll make use of that to explore your network below.

#### Lab 4.1.7: NAT Gateway

Update your VPC template/stack by adding a [NAT gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html).

- Attach your NAT GW to the subnet you created earlier.

- Provision and attach a new Elastic IP for the NAT gateway.

We need a private instance to explore some of the concepts below. Let's
add a new subnet and put a new EC2 instance on it. Add them to your
existing instance stack.

- The new subnet must have a unique netblock.

- The NAT gateway should be the default route for the new subnet.

- Aside from the subnet association, configure this instance just like
  the first one.

- This instance will not have an Elastic IP.

##### Question: Access

_Can you find a way to ssh to this instance?_

##### Question: Egress

_If you can ssh to it, can you send traffic out?_

##### Question: Deleting the Gateway

_If you delete the NAT gateway, what happens to the ssh session on your private
instance?_

##### Question: Recreating the Gateway

_If you recreate the NAT gateway and detach the Elastic IP from the public EC2
instance, can you still reach the instance from the outside?_

Test it out with the AWS console.

#### Lab 4.1.8: Network ACL

Add Network ACLs to your VPC stack.

First, add one on the public subnet:

- It applies to all traffic (0.0.0.0/0).

- Only allows ssh traffic from your IP address.

- Allows egress traffic to anything.

##### Question: EC2 Connection

_Can you still reach your EC2 instances?_

Add another ACL to your private subnet:

- Only allow traffic from the public subnet.

- Allow only ssh, ping, and HTTP.

- Allow all ports for egress traffic, but restrict replies to the
  public subnet.

_Verify again that you can reach your instance._

### Retrospective 4.1

For more information, read the [AWS Documentation on VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

## Lesson 4.2: Integration with VPCs

### Principle 4.2

*VPCs are most useful when connected to external resources: other VPCs,
other AWS services, and corporate networks.*

### Practice 4.2

VPCs provide important isolation for your resources. Often, though, they
need to be connected to other services to poke holes through those walls
of isolation.

#### Lab 4.2.1: VPC Peering

Copy the VPC template you created earlier and modify it to launch a
private VPC in another region.

- Add a new [CIDR block](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#VPC_Sizing)
  for this VPC that doesn't overlap with the original one.

- Don't attach an Internet gateway or NAT gateway to the new VPC. The
  new VPC will be private-only.

- Update both VPC stacks to accept the netblock of the peering VPC as
  a parameter, so that you can...

- add network ACLs in each VPC that allow all traffic in from the
  other VPC, and allow all traffic out from the source VPC.

Create a separate stack that will create a
[peering](https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-basics.html)
link between the 2 VPCs.

- Create a [VPC Peering Connection](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpcpeeringconnection.html)
  from one to the other.

- Add a route in each VPC that sends traffic for the other VPC's CIDR
  to that VPC.

- The VPC IDs should be passed as stack parameters.

#### Lab 4.2.2: EC2 across VPCs

Create a new EC2 template similar to your original one, but without an
Elastic IP.

- Launch it in your new private VPC.

##### Question: Public to Private

_Can you ping this instance from the public instance you created earlier?_

##### Question: Private to Public

_Can you ping your public instance from this private instance? Which IPs are
reachable, the public instance's private IP or its public IP, or both?_

Use traceroute to see where traffic flows to both the public and private IPs.

#### Lab 4.2.3: VPC Endpoint Gateway to S3

VPC endpoints are something you'll see in practically all of our client
engagements. It's really useful to know about them, but we realize the
entire VPC topic is more time-consuming than most.

Create a [VPC endpoint](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpcendpoint.html)
connection from your private VPC to S3.

- Add the VPC endpoint gateway to your private VPC's CFN template.
  Pass the S3 bucket name as a parameter so it can be included in
  the policy.

- Rework your access controls a bit to accommodate using a VPC
  endpoint:

  - Change the egress NACL rules on the subnet where the endpoint is
    attached so that they allow all traffic (see "Network ACL rules" in
    [Troubleshoot Issues Connecting to S3 from VPC Endpoints](https://aws.amazon.com/premiumsupport/knowledge-center/connect-s3-vpc-endpoint/).

  - In the bucket's [policy document](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints-s3.html#vpc-endpoints-policies-s3),
    grant access from your VPC and endpoint.

  - In the endpoint policy, grant access to the bucket you created in the S3 lesson.

After you update the stack, make sure you can reach the bucket from the
instance in your private VPC.

_Note: Try this out, but don't get stalled out here.If you're not
making good progress after a few hours, even with the help of others,
document where you're at and what's not working for you, then move on.
Even though this is a valuable foundation, we have more important things for
you to learn._

### Retrospective 4.2

#### Question: Corporate Networks

_How would you integrate your VPC with a corporate network?_

## Further Reading

- [VPN](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpn-connections.html)
  connections provide a way to connect to customer-premise networks.

- [VPC Endpoints](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-endpoints.html)
  provide a way to connect VPC privately to many more Amazon
  services, protecting any of that service traffic from traversing
  the open Internet.

- [Amazon VPC-to-Amazon VPC Connectivity Options](https://docs.aws.amazon.com/aws-technical-content/latest/aws-vpc-connectivity-options/amazon-vpc-to-amazon-vpc-connectivity-options.html)
  describes many more options and design patterns for using VPCs.

- Jellili Adebello did a Sharing is Caring presentation about
  [Multiple VPC deployments with a pipeline](https://github.com/stelligent/multi-vpc-pipeline)
  on 2018-10-12.
