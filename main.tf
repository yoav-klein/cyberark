
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {}


locals {
  instance_count = 2
}

module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"

  pub_key_path = "${path.module}/aws.pub"

  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  instance_count = local.instance_count
}

module "alb" {
  source = "./load-balancer"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

resource "aws_lb_target_group_attachment" "attachment" {
  count            = local.instance_count
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2.instance_ids[count.index]
  port             = 80
}

