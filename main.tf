
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
}

provider "aws" {}


module "vpc" {
    source = "./vpc"
}

module "ec2" {
    source = "./ec2"
    
    pub_key_path = "${path.module}/aws.pub"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnet_ids
    instance_count = 2
}

module "load_balancer" {
    source = "./load-balancer"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.public_subnet_ids
}
