terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    backend "s3" {
        bucket = "blackhat-codeyou-demo-terraform-bucket"
        key    = "terraform/state/blackhat-demo/code-you/terraform.tfstate"
        region = "us-east-2"
        encrypt = true
        
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-east-2"
    profile = "blackhat-user"
}

# Create network infrastructure
module "blackhat_network_infra" {
    source = "./modules/network-infra"
    vpc_id = "vpc-3771c65c" # Grabbed from the console
}

module "blackhat_compute_infra" {
    source = "./modules/compute-infra"
    security_groups = compact(module.blackhat_network_infra.security_groups)
    vpc_id = module.blackhat_network_infra.vpc_id
    subnets = compact(module.blackhat_network_infra.subnets)
    launch_template_key_name = "blackhat_codeyou_demo_keypair"
    kali_subnet = module.blackhat_network_infra.public_subnet
}
