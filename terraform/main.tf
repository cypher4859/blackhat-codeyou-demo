terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
}

# Create network infrastructure
module "blackhat_network_infra" {
    source = "./modules/network-infra"
    vpc_id = ""
}
# Create the compute infrastructure (ALB)
# Create the ECS Infra
