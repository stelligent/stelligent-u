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
  - [Lesson 15.5: Setting Up ECR for Use with EKS](#lesson-155-setting-up-ecr-for-use-with-eks)
    - [Principle 15.5](#principle-155)
    - [Practice 15.5](#practice-155)
      - [Lab 15.5.1: Create ECR Repository](#lab-1551-create-ecr-repository)
      - [Lab 15.5.2: Push Image to ECR](#lab-1552-push-image-to-ecr)
    - [Retrospective 15.5](#retrospective-155)
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
  `kubectl run --generator=run-pod/v1 busybox --image=busybox:latest -- sleep 3000`

> The result of the command should be `pod/busybox created`

- In the `kubectl` command above the option `--generator=run-pod/v1` is
  used to launch a single pod
- In the `kubectl` command above the pod is being named `busybox`
- In the `kubectl` command above the Docker image being used is
  `busybox:latest`
- In the `kubectl` command above the entrypoint command for the busybox
  container being used is `sleep 3000`

Now that the pod has been deployed there are some commands that can be
used to inspect the status of the pod.

- Run command `kubectl get pods`
  - The results of the command should show the `busybox` pod's name, number
    of containers already in the pod, status, number of restarts and age.
  - The status of the pod should be `Running`
- Run command `kubectl describe pod busybox` and inspect results
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

#### Lab 15.2.2: Pulling Definition File of Existing Pod

- Run the command `kubectl get pod busybox -o=yaml > busybox-pod-definition-lab-22.yaml`
  - Open `busybox-pod-definition-lab-22.yaml` in a text editor.
  - This is what a [pod definition file](https://kubernetes.io/docs/concepts/workloads/pods/#pod-templates)
    looks like.
  - This file contains the details of the deployed pod. Most of these
    details are attached during pod creation.
- Run the command `kubectl delete pod busybox` to delete the pod.

The next section will go over creating pod definitions files.

#### Lab 15.2.3: Generating New Pod Definition File

This section will go over standing up pods using definition files.
Definition files are useful because they can be put into version control
and used in to lock in pod configuration.

- Run the command:
  `kubectl run --generator=run-pod/v1 busybox --image=busybox:latest \
  --dry-run -o=yaml -- sleep 3000 > busybox-pod-definition-lab23.yaml`

- Open `busybox-pod-definition-lab22.yaml`
  - Compare this definition file to the file
  `busybox-pod-definition-lab-22.yaml` generated in [Lab 15.2.2](#lab22-pulling-definition-file-of-existing-pod)
  - Notice how the newly generated definition file has less attributes.
    All the missing attributes are generated by default at pod creation
    if they are not specified in the pod definition file.
  - The `apiVersion:` field is used to specify what api to use for the
    resource type.
  - The `kind:` field is used to specify what type of kubernetes
    resource is being created.
    - The `apiVersion:` and `kind:` fields are dependent on each other.
      All resource type do not use the same value for the `apiVersion:`
      field. Some of the other resource types will be talked about
      later in this course.
  - Notice the `metadata:` field has a `name:` field within it. The
    value specified for this field is the name of the pod.
    - Other fields can be specified under the `metadata:`field. Some of
      these fields could be `labels:` and `namespace:`.  These fields
      are used for linking pods to specific namespaces, deployments and
      other kubernetes resources.
  - Inspect the `spec:` field and notice in the `containers:` field
    there's an array with details about which image and entrypoint
    commands to use for the container.
    - Unless a private Docker repository is specified the `image:` field
      will try to pull from [Docker Hub](https://hub.docker.com/search?q=&type=image)

#### Lab 15.2.4: Standing Up Pods Declaratively

Now that we've got a pod definition file create we can launch a pod with it.

- Run the command: `kubectl create -f busybox-pod-definition-lab23.yaml`

> The result of the command should be `pod/busybox created`

- Run command `kubectl get pods`. The newly created pod should appear in
  the list.
- Run command `kubectl describe pod busybox` to view information about the
  pod.

After you're done inspecting the pod, run the kubectl command that will
delete the pod.

### Retrospective 15.2

Read more about the [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)

## Lesson 15.3: Standing Up Deployment

### Principle 15.3

*A Deployment provides declarative updates for Pods and ReplicaSets.*

### Practice 15.3

Now that you've learned how to stand up pods imperatively using the
`kubectl` and declaratively using definition files, you will learn how to
stand up [deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
using the same methods.

#### Lab 15.3.1: Standing Up Deployment Imperatively

- Run the command:
  `kubectl create deployment nginx-deployment --image=nginx:latest`

> The result of the command should be `deployment.apps/nginx-deployment created`

- Try running the [kubectl](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong-)
  to get the list of deployments present in the cluster.
  - Your deployment should show up in the list of deployments
- Run the command: `kubectl describe deployment nginx-deployment`
  - The results should show basic information about the deployment. Some
    of the information would be:
    - Number of replicas in the deployment
    - Update strategy of the deployment
    - Container definition for pod of the deployment
    - Events about the deployment
    - Label selectors used to determine what pods are part of the
      deployment
- Run the command: `kubectl get pods`
  - There should be a pod returned named `nginx-deployment-*`. This pod is
    part of the deployment.
- Make note of the pod name.
  - Try running the kubectl command to delete the pod and wait a for the
    pod to delete. After the pod has been deleted, run `kubectl get pods`

##### Question: Pods after Deletion

_Why do you think there were still pods returned from the
`kubectl get pods` command after you deleted the pod?_

##### Question: Standalone Pods

_Can you think of any [use cases](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#use-case)
for deployments over using standalone pods?_

#### Lab 15.3.2: Pulling Definition File of Existing Deployment

Now that your deployment is up and running, you should be able to
generate the definition file of the existing deployment. The process of
generating the definition file of a deployment is very similar to the way
the pod definition file of the existing pod definition file was generated
in the previous lab.

- Try running the `kubectl` command to generate the deployment definition
  file of your existing deployment in yaml. Put the results into a file
  named `nginx-deployment-lab32.yaml`
  - Use the [kubectl](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get)
    docs for reference if you need it.
  - Inspect the file `nginx-deployment-lab32.yaml`. Notice how the file
    has different values for the `apiVersion:` and `kind:` fields than
    the pod definition file.
  - The definition file has some fields of that are not present in a pod
    definition file.
- Run the command: `kubectl delete deployment nginx-deployment`

The next section will cover creating deployment with definition files.

#### Lab 15.3.3: Generating New Deployment Definition File

This section will go over creating deployment definition files using
`kubectl`.

- Run the command:
  `kubectl create deployment nginx-deployment --image=nginx:latest \
  --dry-run -o=yaml > nginx-deployment-lab33.yaml`
  to generate a deployment definition file.
- Compare this newly created definition file to the one created in the
  previous lesson.
- Look at the field `strategy:` in the definition file created in the
  previous section.
  - This field refers to the update policy for the deployment. The strategy
    field in this file is the default update strategy if another one is not
    specified in the definition file.
- Look at the sub-field `template:` under `spec:`. This field contains the
  pod definition for pods launched in this deployment. The pod format is
  the same format used when making a pod definition file.
- Look at the field `replicas:` under the `spec:` field. The number
  specified in this field determines how many pods are part of the
  deployment. The default value is 1. The deployment will keep spinning up
  pods until it has the desired amount.
  - If a pod in a deployment is deleted or crashes, another pod will spin
    up in its place based on the pod definition defined in the deployment.
- The `selector:` field  is used to link pods to the deployment. The label
  under the `matchLabels:` field would need to be present in the pod
  definition so the pod would show up in the ReplicaSet.

##### Question: Dry-Run Flag

_What do you think will happen if the `--dry-run` flag is not included in
the kubectl command used to generate the deployment definition file?_

#### Lab 15.3.4: Standing Up Deployment Declaratively

- Open `nginx-deployment-lab33.yaml` in a text editor and change the value
  in the `replicas:` field to 3
  - Run command `kubectl apply -f nginx-deployment-lab33.yaml`
  - Check the status of your deployment and check the number of pods
    present for your deployments.
- The deployment can be scaled up or down with the `kubectl`
  - Run the command:
    `kubectl scale deployment.v1.apps/nginx-deployment --replicas=6`
  - Insert the deployment and deployed pods using `kubectl`
  - There are other scaling methods.  Take some time to read through the
    [scaling deployments documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment)

#### Lab 15.3.5: Introduction to ReplicaSets

When deployments are made, ReplicaSet are created with them. The
ReplicaSets control the number of pods deployed with each deployment.

- Run command `kubectl get replicaSets` to view the replica set created
  with your deployment.
  - Notice the value specified under `DESIRED` is the same number specified
    in the deployment file or the number that's specified when the
    deployment is scaled with `kubectl`
- Run command `kubectl describe replicaSet <YOUR REPLICA SET NAME>`
  - Inspect the results of the command. Notice the similarities between
    the pods and deployments describe command output.
  - [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
    are a Kubernetes resource and can be defined with definition files too.

Try generating the yaml definition file of the existing replica set using
`kubectl` commands.

##### Question: ReplicaSet Deletion

_What do you think will happen if the ReplicaSet is deleted?  Open a
second terminal and run the command `watch kubectl get all` to inspect the
resources deployed with the cluster. Run the command to delete the
ReplicaSet in a different terminal and watch the kubernetes resource. Why
do you think pods are terminating?_

### Retrospective 15.3

Take a moment to try and think of some situations where using using
`kubectl` commands over definitions files would be appropriate when
working with a kubernetes cluster. Consider how this can be beneficial
if there are multiple deployments of different services for an application.

Keep the deployment from this section running for use in the next section.

## Lesson 15.4: Perform Rolling Update on Deployment

### Principle 15.4

*Rolling updates allow Deployments' update to take place with zero
downtime by incrementally updating Pods instances with new ones.*

### Practice 15.4

Next we're going to perform a [rolling update](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)
on the deployment that was created in [Lab 15.3.4](#lab1534-standing-up-deployment-declaratively).

#### Lab 15.4.1: Rolling Update of Deployment with Definition File

Make a copy of the `nginx-deployment-lab33.yaml` file and name it
`nginx-deployment-lab41.yaml`

- Open `nginx-deployment-lab41.yaml`
  - Change the image to `nginx:alpine`
  - Change the `replicas` field to have the value `10`
- Open a second terminal and run the command `watch -n .5 kubectl get pods`
- Open a third terminal and run the command
  `watch -n .5 kubectl get deployments`
- Deploy the new definition file `nginx-deployment-lab41.yaml`
  - Make note of the the pod names change and the statuses of the
    deployment.
  - Verify the image has been updated by inspecting the deployed pods
    and deployment.
- Keep the `watch` commands running in the other terminals for the next
  section.

##### Question: Different Definition File

_Why isn't the deployment name changing when a different deployment
definition file is being used?_

##### Question: Update Behaviors

_How are the update behaviors set? *Hint:* Pull the configuration of the
deployment using the kubectl and inspect the `strategy:` field that's
within the `spec:` field._

#### Lab 15.4.2: Changing Image of Deployment Using kubectl

As you've seen in previous parts of this module, there are numerous ways
to interact with kubernetes resources. In this section we'll be going
over some other `kubectl` ways to update deployments.

- Run the command:
  `kubectl set image deployment/nginx-deployment nginx=nginx:stable --record`
  - Verify the image has been update by inspecting the deployed pods and
    deployment.

Next we will try using the [`kubectl edit`](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#kubectl-edit)
command now to update the deployment.

- Run the command: `kubectl edit deployment nginx-deployment`
  - The command should open the existing configuration of the deployment
    in a [vim editor](https://github.com/vim/vim)
  - Scroll down the configuration and update the image to `nginx:perl`
  - After editing, save the changes and the deployment should begin
    updating to the new image.
    - If anything fails when trying to run the `kubectl edit` command,
      the attempted file change is saved to a file in `/tmp`

##### Question: Edit Name

_What do you think will happen if you try to edit the name of the
deployment when you run the `kubectl edit` commands? Try this and see
what happens._

##### Question: Edit Replica Count

_What do you think will happen if you try to edit the replica count when
you run the `kubectl edit` commands? Try this and see what happens._

Remove all deployments from the cluster before starting the next section.

### Retrospective 15.4

*Take a moment and consider how rolling updates could be effective when
needing to quickly [rollback](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment)
after a new application version fails. Think about how having different
deployment definition files for each application version could facilitate
fast rollouts or rollbacks for an application.*

## Lesson 15.5: Setting Up ECR for Use with EKS

### Principle 15.5

*ECR is a fully-managed Docker container registry.*

### Practice 15.5

In this section you will be setting up an [ECR repository](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html)
to use with your EKS cluster.  Ensure that you have have Docker running
on your local machine for this section.

#### Lab 15.5.1: Create ECR Repository

- Deploy the `ecr.yaml` file located in the `ecr` directory of this
  module.
  - You will need to specify a value for the `Prefix` parameter of this
    template.

When your CloudFormation stack creation is done, navigate to your newly
created ECR repository in the AWS console.

- The name of your repository should be in the outputs of the CloudFormation
  stack under `ECRRepoName`

#### Lab 15.5.2: Push Image to ECR

Once you have navigated to your ECR repository:

- Change to the `sample_app` directory of this module in your terminal.
- In the AWS console click the `View push commands` and follow the steps
  for [authenticating](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Registries.html#registry_auth)
  and [pushing](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)
  to your ECR repository.

Look in your ECR repository and verify that the new images is in the list.

### Retrospective 15.5

#### Question: ECR Access

_How do you think [ECR access](https://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_on_EKS.html)
is handled in AWS with respect to EKS?  *Hint:* Take a look at the ECR
policy defined in the `ecr.yaml` file that was deployed in this lab. Also
consider taking a look over the resources `eksctl` deployed with
CloudFormation._

The next section of this module we will cover deploying this custom image
into the EKS Cluster.

## Lesson 15.6: Creating Custom Deployment

### Principle 15.6

*A Service is an abstraction which defines a logical set of Pods and a
policy by which to access them.*

### Practice 15.6

In this lesson you'll create a custom deployment using the Docker image
created in then last section.

#### Lab 15.6.1: Creating Custom Deployment Definition File

Using what you've learned from the previous modules, create a deployment
definition file.

- Name the deployment `custom-deployment`
- Specify the image uri as the one in your ECR repository.
- Expose the [container port](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#exposing-pods-to-the-cluster)
  `3000` in the pod definition.
- Add an [env variable](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/#define-an-environment-variable-for-a-container)
  to the pod spec named `REACT_APP_BG_COLOR` and set the value to a
  [Bgcolor value](https://cssgradient.io/)
- Set replicas count to `1`

Launch the deployment when the definition file has been completed. Be
sure to inspect the status of the deployment and pod before moving to the
next section.

##### Question: Docker Registry Access

_How do you think [Docker registry access](https://kubernetes.io/docs/concepts/containers/images/)
is handled for images other than the public Docker Hub images and the ECR
repository created in this course?_

#### Lab 15.6.2: Introduction to Services in Kubernetes

In this section we'll be setting the deployment up with a
[service](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#exposing-pods-to-the-cluster)
so we can access it externally.

- Run the command:
  `kubectl expose deployment custom-deployment --type=LoadBalancer \
  --name=custom-service --dry-run -o=yaml >> custom-service.yaml` to
  generate the service definition file.
- Open the file and inspect the fields.
- The `type:` field under the `spec:` field specifies what type of service
  this will be.  Kubernetes supports [other service types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
  as well. For this exercise you'll be using the `LoadBalancer` type.
- The `targetPort:` field under `ports:` maps to the container port of
  the pod.
- The `port:` field under `ports:` will be the port the service advertises
  on the loadbalancer.
- The service determines which pods to bind to by looking for any pods
  that have the label specified under the `selector:` field.

Read through the [documentation on a service](https://kubernetes.io/docs/concepts/services-networking/service/)
in Kubernetes.

#### Lab 15.6.3: Deploying Kubernetes Service

Now that you've examined your service definition file, deploy it to the
kubernetes cluster.

- Once it's deployed use `kubectl` to describe the service and look for
  the values at `LoadBalancer Ingress:` and `Port:`
  - Go to `LoadBalancer Ingress:`:`Port:` in your browser to view the app.
  - The background color should be the color specified in the env variable
    `REACT_APP_BG_COLOR` in the deployment definition file.

When using kubernetes with a cloud provider that supports external
[load balancers](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer),
a load balancer is provisioned for the service.

##### Question: Multiple External Ports

_Do you think it's possible to map multiple external ports in a kubernetes
service to a pod port? Try editing the service definition file to
facilitate this. Why would it be necessary to map multiple external ports
to a single pod?_

### Retrospective 15.6

#### Question: Delete Deployment

_What will happen to the service if the deployment is deleted?_

## Lesson 15.7: Perform Rolling Update on Custom Deployment

### Principle 15.7

*If a Deployment is exposed publicly, the Service will load-balance the
traffic only to available Pods during the update.*

### Practice 15.7

You'll be a performing a rolling update on the deployment to change the
background color of the deployment.

#### Lab 15.7.1: Change Background Color

Set the replica count of your existing deployment to `5` using `kubectl`

- Copy the custom deployment definition file to a file name
  `custom-deployment-lab71.yaml`
  - Set the replicas count to `5` in the new definition file.
  - Set the `REACT_APP_BG_COLOR` environment variable to a different BG
    color value.

Apply the new definition file and refresh the browser at the service
address until you see your change reflected.

##### Question: Deployment vs Standalone Pods

_What are the benefits of using a service with pods that are part of a
deployment over using a service with standalone pods?_

*Remove the service and deployment from the cluster after finishing
this module using the commands below*

- `kubectl delete service custom-service`
- `kubectl delete deployment custom-deployment`

#### Lab 15.7.2: Cleanup

- You can retrieve your cluster name using the `eksctl get clusters` command.
- Delete the cluster using  the `eksctl delete cluster <$CLUSTER_NAME>` command.

*All the Docker images in the ECR repository need to be deleted before
the ECR CloudFormation stack can be deleted.*

### Retrospective 15.7

Read some more about [rolling updates](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)

## Further Reading

- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
  walks you through setting up a Kubernetes cluster manually to learn
  the ins and outs of K8s.
- [Helm](https://helm.sh/docs/using_helm/#quickstart) is the defacto
  application package manager for Kubernetes.
