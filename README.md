# line10
SRE Assessment for LineTen


```This is not for production use```

To be at a best practice level, please consider the following changes:

1. Terraform state need to be setup on some remote location, currently is on local.
2. The ec2 keypair is in the repo which should be saved on git at all.

### DOCKER ###

The docker directory contains a sample python app, that says Hello!
It is dockerized and pushed to heksahiti/lineten-test registry on dockerhub

### TERRAFORM ###

The terraform directory contains the code for provisioning an EC2 instance on AWS.
The instance has a security group with allowed ingress rules on ports 80, 5500 and 22 from anywhere (I know).
For convenience there's a Makefile in there to make it easier to run the terraform commands.
The terraform code uses a local aws profile which is in the `provider.tf` file, which needs to be configured on your local aws-cli
The terraform state is also local, idealy I would use gitlab, terraform cloud or aws s3 to host the state.
When you create the resources on the /ec2/ directory a key-pair will be created in there, this should not be commited to the repo.
Two environment variables are needed to be exported on your local terminal in order to run the make commands:
 - AWS_REGION ----- example: export AWS_REGION=eu-central-1
 - ENVIRONMENT ---- example: export ENVIRONMENT=env
The ENVIRONMENT variable should be the name of the `tfvars` file, in this case `env`, you can add more files (dev, test, staging, prod) to have different configs for different envs.

### K8S ###

The k8s directory contains the `/line10-chart`, which would deploy the sample app on a k8s cluster
I haven't included any terraform code for the EKS cluster, but I would go with the official tf eks module: https://github.com/terraform-aws-modules/terraform-aws-eks and with some additional supporting resources.
The helm charts would be deployed on the cluster with ArgoCD.
The helm charts has a deployment resource to manage the pods, a service with type ClusterIP and an ingress that would be hooked to a ingress controller.

