## Purpose

This repo can serve as a basic starter template for setting up a terraform dev environment in VS code.

Followed along with this video: [Learn Terraform (and AWS) by Building a Dev Environment - Full Course for Beginners](https://www.youtube.com/watch?v=iRaai1IBlB0). I stopped just after the EC2 instance was successfully created around the 1 hour mark. A good amount of terraform can be learned getting to that point.

- Resources are prefixed with 'devtest' in place of the 'mtc' prefix used by video. Change as desired.

## Getting Started

After cloning this repo to your local machine...

1) **Run >** `terraform init` in the working directory 
    - This command installs terraform as defined in **providers.tf**
    - **/.terraform** directory will be created with terraform installed

3) **Run >** `terraform plan`
    - This command shows the resources that will be created in whatever AWS account you have connected to.
    - Resources are created based on comparison of terraform.tfstate (vs) those specified in **main.tf**

4) **Run >** `terraform apply`
    - This command actually creates the resources shown in the terraform plan.
    - You have a chance to 'confirm' before resources are actually created.
    - Resources to be created are specified in **main.tf**, but only those not already in terraform.tfstate file will be created (as mentioned above).

### providers.tf

- Edit providers.tf as needed to match the AWS account you wish to connect to  
  - **IMPORTANT: the connection 'profile' referenced in 'provider' section must be setup on your machine**

- Run 'terraform init' once this provider.tf file is edited as desired and added to a new directory.  
  - **Doing so will install that specified (or latest) version of Terraform into that working directory**

### main.tf

- (9) AWS resources are added by this file.
  - vpc 
  - public subnet
  - internet gateway
  - public route table
  - default route
  - route table association (between route table and subnet)
  - security group to the vpc with ingress/egress
  - generate keypair (for ec2 access)
  - spin up EC2 instance with AMI referenced by **datasources.tf**

### datasources.tf

- Gets a "reference" to the latest Amazon Linux 2023 AMI


### Cleanup

When you are done with this project and no longer want the resources sitting in your AWS account:

- **Run >** `terraform destroy`
  - This command gets rid of all resources created above so you don't have unexpected charges in the AWS account.
  - You will see the resources impacted before they are actually destroyed, then you confirm.

