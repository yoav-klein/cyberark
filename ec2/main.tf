
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
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


#resource "aws_vpc" "vpc" {
#    cidr_block = "10.0.0.0/16"
#}

#resource "aws_subnet" "subnet" {
#    vpc_id = aws_vpc.vpc.id
#    cidr_block = "10.0.1.0/24"
#}


resource "aws_security_group" "sg" {
  name = "containerInstanceSG"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "ssh connectivity"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "deployer" {
  key_name   = "myKey"
  public_key = file(var.pub_key_path)
}

resource "aws_instance" "ec2_instance" {
  count = 2
  availability_zone    = data.aws_availability_zones.available.names[0]
  ami                  = "ami-03dbf0c122cb6cf1d" # Amazon Linux AMI
  key_name             = aws_key_pair.deployer.key_name
  instance_type        = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.sg.id]
  
  tags = {
    Name = "containerInstance"
  }

}

resource "aws_eip" "eip" {
    
}
