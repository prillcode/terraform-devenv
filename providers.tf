# Setup terraform to use the desired provider (in this case aws v3.0 from hashicorp is used)
# - If version specified, that version will be installed on your dev machine 
# - Alternatively, remove 'version' tag to use latest available
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


# The default provider configuration; resources that begin with `aws_` will use it as the default
# - Resources can reference this provider as `aws`.
# Connection profile must be setup in ~/.aws/config 
# - Connects to AWS Acct: 814643882586 (aws_ms_cloudops_dev) after "sso handshake"
provider "aws" {
  region  = "us-east-1" #below 'profile' also has region set but will be overridden with this value
  profile = "mscloudops_dev"
}

# Additional provider configuration for west coast region 2 (Oregon; 
# resources can reference this as `aws.west2`.
provider "aws" {
  alias   = "west2"
  region  = "us-west-2"
  profile = "mscloudops_dev"
}

