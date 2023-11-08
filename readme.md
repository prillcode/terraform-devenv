## Purpose

This repo can serve as a basic starter template for setting up a terraform dev environment in VS code.

Followed along with this video: [Learn Terraform (and AWS) by Building a Dev Environment - Full Course for Beginners](https://www.youtube.com/watch?v=iRaai1IBlB0)

- Resources are prefixed with 'devtest' in place of the 'mtc' prefix used by video. Change as desired.

## Getting Started

### providers.tf

- Edit providers.tf as needed to match the AWS account you wish to connect to  
  - **IMPORTANT: the connection 'profile' referenced in 'provider' section must be setup on your machine**

- Run 'terraform init' once this provider.tf file is edited as desired and added to a new directory.  
  - **Doing so will install that specified (or latest) version of Terraform into that working directory**

### main.tf

- AWS resources are added by this file.
  - vpc 
  - public subnet
  - internet gateway
  - public route table
  - default route
  - route table association between route table and the subnet
  - security group to the vpc with ingress/egress
  - generate keypair for ec2 access
  - spin up EC2 instance with AMI referenced by datasources.tf

### datasources.tf

- Gets a "reference" to the latest Amazon Linux 2023 AMI


### Cleanup

- Be sure to run 'terraform destroy' to get rid of all resources at the end!