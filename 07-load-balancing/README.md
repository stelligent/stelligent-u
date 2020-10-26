# Topic 7: Load Balancers

<!-- TOC -->

- [Topic 7: Load Balancers](#topic-7-load-balancers)
  - [Lesson 7.1: Introduction to Load Balancers](#lesson-71-introduction-to-load-balancers)
    - [Principle 7.1](#principle-71)
    - [Practice 7.1](#practice-71)
      - [Lab 7.1.1: ASG Basics](#lab-711-asg-basics)
        - [Question: Listeners and Target Groups](#question-listeners-and-target-groups)
      - [Lab 7.1.2: Health Checks](#lab-712-health-checks)
        - [Question: Health Checks](#question-health-checks)
        - [Question: ASG Behavior](#question-asg-behavior)
      - [Lab 7.1.3: Secure Sockets](#lab-713-secure-sockets)
        - [Question: SSL Policy](#question-ssl-policy)
        - [Question: Certificate Management](#question-certificate-management)
      - [Lab 7.1.4: Cleanup](#lab-714-cleanup)
    - [Retrospective 7.1](#retrospective-71)
  - [Further reading](#further-reading)

<!-- /TOC -->

## Lesson 7.1: Introduction to Load Balancers

### Principle 7.1

*Application Load Balancers are the best general-purpose service for
distributing web traffic to many servers in multiple availability
zones.*

This section demonstrates the setup, management, and configuration you
may run into in on an engagement concerning Load Balancers. While this
is not an exhaustive look at LBs, this will give you the fundamentals to
know where to start.

### Practice 7.1

This section will get you familiar with the basic setup of an
Application Load Balancer (ALB) and practical configurations you're
likely to encounter in enterprises.

#### Lab 7.1.1: ASG Basics

In Topic 6, you created Auto Scaling Groups (ASGs) with a number of
instances. In this lab, we'll take an ASG with instances that serve a
specific web page on port 80 with HTTP and balance traffic across the
many instances with an ALB.

- Working from the [ASG Template](https://github.com/stelligent/stelligent-u/blob/master/07-load-balancing/asg_example.yaml),
  associate a [target group](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-targetgroup.html)
  with the autoscaling group, giving it a health check on `/index.html`.
  - Be sure to use the Amazon Linux AMI, and not the Amazon Linux 2 AMI. If you
    use the Amazon Linux 2 AMI (this is untested...), you'll have to use
    `amazon-linux-extras` instead of `yum` and install `nginx1.12`
    instead of `nginx`

- Create an internet-facing ALB

- Create an ALB Listener that references the previously created target
  group and ALB.

- Update the AutoScalingGroup to use 'ELB' for HealthCheckType and 30
  for HealthCheckGracePeriod

- Once created, go to the endpoint associated with the Load Balancer.

##### Question: Listeners and Target Groups

_What is the benefit of breaking up the load balancer into specific listeners
and target groups?_

#### Lab 7.1.2: Health Checks

Now, let's update our health check to see what happens when things go
haywire!

- Modify the target group:

  - Update the health check value to be `/BADindex.html`
  - Change the interval to be 20
  - Change the healthy threshold to 2
  - Change the unhealthy threshold to 3
  - Create a target group attribute with key
    `deregistration_delay.timeout_seconds`, value 20

- Wait about two minutes after the stack completes.

- Go to your load balancer endpoint.

##### Question: Health Checks

_What can be controlled with the interval/healthy threshold/unhealthy threshold
settings?_

##### Question: ASG Behavior

_What's happening to the instances in the ASG? How do you know?_

#### Lab 7.1.3: Secure Sockets

Let's fix that bad health check endpoint and add an https listener.

- First, fix your health check and verify everything is working
  smoothly.

- [Create a self-signed certificate locally](https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html)

- Via the aws acm CLI or AWS Certificate Manager console, import your
  newly created certificate, make note of its ARN.

- Add a new listener to your previously created load balancer using
  HTTPS on port 443 and referencing your newly uploaded certificate.

- Let's be extra secure and specify a [security policy](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies)
  on that listener which requires Forward Secrecy (has FS in its
  name).

- Visit your ALB endpoint, add the security exception and enjoy your
  encrypted session.

##### Question: SSL Policy

_What is the trade off of going with a more secure SSL policy?_

##### Question: Certificate Management

_We imported a local certificate into ACM, what other options do you have? How
do those processes work?_

#### Lab 7.1.4: Cleanup

- [Load balancers are expensive](https://aws.amazon.com/elasticloadbalancing/pricing/)
  so delete your stack.

- Delete your imported self-signed cert.

### Retrospective 7.1

Discuss with your mentor: *What are some of the common cloud architectures
where you would want to implement an ALB?*

## Further reading

- [Run Containerized Microservices with Amazon ECS and Application Load Balancer](https://aws.amazon.com/blogs/compute/microservice-delivery-with-amazon-ecs-and-application-load-balancers/)

- [Target Groups and Sticky Sessions](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html)

- [Using path-based routing.](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/tutorial-load-balancer-routing.html)
