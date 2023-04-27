# Topic 15: Kubernetes

<!-- TOC -->

- [Topic 15: Kubernetes](#topic-15-kubernetes)
  - [Guidance](#guidance)
  - [Lesson 15.1: Using eksctl to Standup EKS Cluster](#lesson-151-using-eksctl-to-standup-eks-cluster)
    - [Principle 15.1](#principle-151)
    - [Prerequisites 15.1](#prerequisites-151)
    - [Practice 15.1](#practice-151)
      - [Lab 15.1.1: Standing Up EKS Cluster](#lab-1511-standing-up-eks-cluster)
      - [Lab 15.1.2: Running Commands on Newly Created Cluster](#lab-1512-running-commands-on-newly-created-cluster)
      - [Lab 15.1.3: Deleting EKS Cluster](#lab-1513-deleting-eks-cluster)
    - [Retrospective 15.1](#retrospective-151)
  - [Lesson 15.2: Standing up Pods](#lesson-152-standing-up-pods)
    - [Principle 15.2](#principle-152)
    - [Practice 15.2](#practice-152)
      - [Lab 15.2.1: Standing Up Pods Imperatively](#lab-1521-standing-up-pods-imperatively)
      - [Lab 15.2.2: Pulling Definition File of Existing Pod](#lab-1522-pulling-definition-file-of-existing-pod)
      - [Lab 15.2.3: Generating New Pod Definition File](#lab-1523-generating-new-pod-definition-file)
      - [Lab 15.2.4: Standing Up Pods Declaratively](#lab-1524-standing-up-pods-declaratively)
    - [Retrospective 15.2](#retrospective-152)
  - [Lesson 15.3: Standing Up Deployment](#lesson-153-standing-up-deployment)
    - [Principle 15.3](#principle-153)
    - [Practice 15.3](#practice-153)
      - [Lab 15.3.1: Standing Up Deployment Imperatively](#lab-1531-standing-up-deployment-imperatively)
        - [Question: Pods after Deletion](#question-pods-after-deletion)
        - [Question: Standalone Pods](#question-standalone-pods)
      - [Lab 15.3.2: Pulling Definition File of Existing Deployment](#lab-1532-pulling-definition-file-of-existing-deployment)
      - [Lab 15.3.3: Generating New Deployment Definition File](#lab-1533-generating-new-deployment-definition-file)
        - [Question: Dry-Run Flag](#question-dry-run-flag)
      - [Lab 15.3.4: Standing Up Deployment Declaratively](#lab-1534-standing-up-deployment-declaratively)
      - [Lab 15.3.5: Introduction to ReplicaSets](#lab-1535-introduction-to-replicasets)
        - [Question: ReplicaSet Deletion](#question-replicaset-deletion)
    - [Retrospective 15.3](#retrospective-153)
  - [Lesson 15.4: Perform Rolling Update on Deployment](#lesson-154-perform-rolling-update-on-deployment)
    - [Principle 15.4](#principle-154)
    - [Practice 15.4](#practice-154)
      - [Lab 15.4.1: Rolling Update of Deployment with Definition File](#lab-1541-rolling-update-of-deployment-with-definition-file)
        - [Question: Different Definition File](#question-different-definition-file)
        - [Question: Update Behaviors](#question-update-behaviors)
      - [Lab 15.4.2: Changing Image of Deployment Using kubectl](#lab-1542-changing-image-of-deployment-using-kubectl)
        - [Question: Edit Name](#question-edit-name)
        - [Question: Edit Replica Count](#question-edit-replica-count)
    - [Retrospective 15.4](#retrospective-154)
  - [Lesson 15.4: Setting Up ECR for Use with EKS](#lesson-155-setting-up-ecr-for-use-with-eks)
    - [Principle 15.4](#principle-155)
    - [Practice 15.4](#practice-155)
      - [Lab 15.4.1: Create ECR Repository](#lab-1551-create-ecr-repository)
      - [Lab 15.4.2: Push Image to ECR](#lab-1552-push-image-to-ecr)
    - [Retrospective 15.4](#retrospective-155)
      - [Question: ECR Access](#question-ecr-access)
  - [Lesson 15.6: Creating Custom Deployment](#lesson-156-creating-custom-deployment)
    - [Principle 15.6](#principle-156)
    - [Practice 15.6](#practice-156)
      - [Lab 15.6.1: Creating Custom Deployment Definition File](#lab-1561-creating-custom-deployment-definition-file)
        - [Question: Docker Registry Access](#question-docker-registry-access)
      - [Lab 15.6.2: Introduction to Services in Kubernetes](#lab-1562-introduction-to-services-in-kubernetes)
      - [Lab 15.6.3: Deploying Kubernetes Service](#lab-1563-deploying-kubernetes-service)
        - [Question: Multiple External Ports](#question-multiple-external-ports)
    - [Retrospective 15.6](#retrospective-156)
      - [Question: Delete Deployment](#question-delete-deployment)
  - [Lesson 15.7: Perform Rolling Update on Custom Deployment](#lesson-157-perform-rolling-update-on-custom-deployment)
    - [Principle 15.7](#principle-157)
    - [Practice 15.7](#practice-157)
      - [Lab 15.7.1: Change Background Color](#lab-1571-change-background-color)
        - [Question: Deployment vs Standalone Pods](#question-deployment-vs-standalone-pods)
      - [Lab 15.7.2: Cleanup](#lab-1572-cleanup)
    - [Retrospective 15.7](#retrospective-157)
  - [Further Reading](#further-reading)

<!-- /TOC -->

## Guidance

- Prerequisites: This module requires a basic understanding of Docker and
  how to write a Dockerfile.
- Explore the official docs! See the the Kubernetes [Documentation](https://kubernetes.io/docs/home/),
  [API Reference](https://kubernetes.io/docs/concepts/overview/kubernetes-api/),
  and [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
  docs.
- Explore your curiosity. Try to understand why things work the way they
  do. Read more of the documentation than just what you need to find the
  answers.

## Lesson 15.1: Using eksctl to Standup EKS Cluster

### Principle 15.1

*eksctl is a simple CLI tool for creating clusters on EKS.*

### Prerequisites 15.1

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  needs to be installed.
- The [eksctl](https://eksctl.io/introduction/#installation) will need to
  be installed to use the `cluster.yaml` template in the `eksctl` directory.
- [AWS IAM Authenticator for Kubernetes](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
  needs to be installed as well.

### Practice 15.1

This section gets you started with eksctl. Read more about it on the
[eksctl website](https://eksctl.io/)

Before you can use the eksctl to standup an EKS cluster you'll need to
setup a default AWS profile.

**Follow these additional
steps if you want to use [aws-vault](https://github.com/99designs/aws-vault)**

- Run the command `aws-vault exec <your aws-vault profile>`
  to spawn a shell with your credentials loaded
  - The remainder of the lab can be done from this shell

#### Lab 15.1.1: Standing Up EKS Cluster

Theses steps will launch your EKS cluster.

- Change directory to `eksctl`
- Under the `metadata` section change the `name` field to
  `<your name>-cluster`. This is what your EKS cluster will be called.
- Run command `eksctl create cluster -f cluster.yaml`
  - Creation time is ~16 minutes
  - During creation, eksctl generates CloudFormation templates that
    contain all the VPC, IAM and EC2 components for the EKS cluster.
- EKS kubectl access is given to the IAM user that
  stood up the EKS cluster using eksctl.
  - If you want to configure EKS access for another IAM user you will need to use
    this [guide](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

**You may need to specify availability zones in the `cluster.yaml` file
if you experience an error like the one below:**

> Cannot create cluster 'test-cluster' because us-east-1e, the targeted availability
zone, does not currently have sufficient capacity to support the cluster. Retry and
choose from these availability zones: us-east-1a, us-east-1b, us-east-1c,
us-east-1d, us-east-1f (Service: AmazonEKS; Status Code: 400; Error Code:
UnsupportedAvailabilityZoneException; Request
ID:a4b1201d-6bb1-4c4f-98f8-8fb278f48bf9)

#### Lab 15.1.2: Running Commands on Newly Created Cluster

Now that you've successfully stood up the EKS cluster you're going to test
running commands against the cluster.

- During the creation of the EKS cluster, eksctl creates a kube-config file
  in the home directory of your machine under `.kube/config`.
- The kube-config file allows you to run `kubectl` commands against the
  cluster deployed in EKS.
  - Try running the command `kubectl get nodes`
    - This command should result in listing the nodes from the EKS cluster.
  - Troubleshooting [guide](https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/)
    if the kubectl command is not working against the EKS cluster.
- Run the command `kubectl get pods --all-namespaces` to see all
  kubernetes system pods.
- Try running other kubectl commands to see what the EKS cluster has on
  it by default.

#### Lab 15.1.3: Deleting EKS Cluster

When you're done testing commands on the EKS cluster, here are the steps
for deleting it using the `eksctl`.

**Do not delete the cluster unless you're done using it for day. It will
be used in later sections.**

- Change directory to `eksctl`
- Run command `eksctl delete cluster <$CLUSTER_NAME>`
  - Deletion command takes ~3 minutes to finish
  - During the deletion eksctl calls the CloudFormation API to delete the
    CloudFormation templates.
    - The CloudFormation takes ~15 minutes to delete completely from the
      AWS account.

### Retrospective 15.1

Review the eksctl [basic usage commands](https://eksctl.io/introduction/)

## Lesson 15.2: Standing up Pods

### Principle 15.2

*A Pod is the basic execution unit of a Kubernetes application–the
smallest and simplest unit in the Kubernetes object model that you
create or deploy.*

### Practice 15.2

Now that you have a kubernetes cluster, you're going to learn how to launch
[pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)
imperatively using the `kubectl` and declaratively using definition files.

#### Lab 15.2.1: Standing Up Pods Imperatively

Run the command `kubectl get pods`.  The results should show that there
are not any pods deployed in the default namespace.

- Run the command:
  `kubectl run nginx --image=nginx `

> The result of the command should be `pod/nginx created`

- In the `kubectl` command above the pod is being named `nginx`
- In the `kubectl` command above the Docker image being used is
  `nginx:latest`


Now that the pod has been deployed there are some commands that can be
used to inspect the status of the pod.

- Run command `kubectl get pods`
  - The results of the command should show the `nginx` pod's name, number
    of containers already in the pod, status, number of restarts and age.
  - The status of the pod should be `Running`
- Run command `kubectl describe pod nginx` and inspect results
  - The results should show basic information about the pod.  Some of the
    information would be:
    - [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
      the pod is deployed under
    - [Node](https://kubernetes.io/docs/concepts/architecture/nodes/) the
      pod is deployed on
    - IP of the pod
    - Information about containers within the pod
    - [Volume mounts](https://kubernetes.io/docs/concepts/storage/volumes/)
      to the pod
    - [Tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/)
      of the pod
    - Events about the pod i.e. pod node assignment, image pulling, pod
      startup status
- Run command `kubectl delete pod nginx` and inspect results

### Retrospective 15.2

Read more about the [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)

## Lesson 15.3: Expose the Kubernetes services running on EKS
#### Lab 15.3.1: Standing Up Deployment
- Run command `kubectl apply -f nginx-deployment.yaml`
  - The results of the command should show `deployment.apps/nginx-deployment created`

- Run command `kubectl get pods -l 'app=nginx' -o wide | awk {'print $1" " $3 " " $6'} | column -t`
  - Verify that your pods are running and have their own internal IP addresses:

#### Lab 15.3.2: Expose externally using a load balancer.
- Run command `kubectl expose deployment nginx-deployment  --type=LoadBalancer  --name=nginx-service-loadbalancer`
  - The results of the command should show `service "nginx-service-loadbalancer" exposed`

- Run command `kubectl get service/nginx-service-loadbalancer |  awk {'print $1" " $2 " " $4 " " $5'} | column -t`
  - Get information about LoadBalancer external IP addresses, the command should show `
  NAME                        TYPE          EXTERNAL-IP                                                              PORT(S)
  nginx-service-loadbalancer  LoadBalancer  ae07f5c3761c04df981fd54c2f9a2401-1128025709.us-east-1.elb.amazonaws.com  80:30841/TCP
  `

- Open a browser and check the HTTP page of external ip


### Retrospective 15.3

This section demo how you can easily deploy a Nignx micro service and expose it to external user


## Lesson 15.4: Setting Up ECR for Use with EKS

### Principle 15.4

*ECR is a fully-managed Docker container registry.*

### Practice 15.4

In this section you will be setting up an [ECR repository](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html)
to use with your EKS cluster.  Ensure that you have have Docker running
on your local machine for this section.

#### Lab 15.4.1: Create ECR Repository

- Deploy the `ecr.yaml` file located in the `ecr` directory of this
  module.
  - You will need to specify a value for the `Prefix` parameter of this
    template.

When your CloudFormation stack creation is done, navigate to your newly
created ECR repository in the AWS console.

- The name of your repository should be in the outputs of the CloudFormation
  stack under `ECRRepoName`

#### Lab 15.4.2: Push Image to ECR

Once you have navigated to your ECR repository:

- Change to the `sample_app` directory of this module in your terminal.
- In the AWS console click the `View push commands` and follow the steps
  for [authenticating](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Registries.html#registry_auth)
  and [pushing](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)
  to your ECR repository.

Look in your ECR repository and verify that the new images is in the list.

### Retrospective 15.4

#### Question: ECR Access

_How do you think [ECR access](https://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_on_EKS.html)
is handled in AWS with respect to EKS?  *Hint:* Take a look at the ECR
policy defined in the `ecr.yaml` file that was deployed in this lab. Also
consider taking a look over the resources `eksctl` deployed with
CloudFormation._

The next section of this module we will cover deploying this custom image
into the EKS Cluster.

