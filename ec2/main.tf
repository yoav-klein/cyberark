
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
}


resource "aws_security_group" "sg" {
  name = "mySecurityGroup"
  vpc_id = var.vpc_id

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

resource "aws_key_pair" "deployer" {
  key_name   = "myKey"
  public_key = file(var.pub_key_path)
}

resource "aws_instance" "ec2_instance" {
  count = var.instance_count

  ami                  = "ami-03dbf0c122cb6cf1d" # Amazon Linux AMI
  key_name             = aws_key_pair.deployer.key_name
  instance_type        = "t3.micro"
  vpc_security_group_ids  = [aws_security_group.sg.id]
  subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]

  tags = {
    Name = "myInstance${count.index}"
    Environment = "exercise"
  }

  user_data = <<-EOF
#!/bin/bash

amazon-linux-extras enable nginx1

yum update -y
yum install -y nginx

systemctl start nginx

hostnamectl set-hostname app${count.index + 1}

EOF

}

resource "aws_eip" "eip" {
    count = length(aws_instance.ec2_instance)

    instance = aws_instance.ec2_instance[count.index].id
    vpc = true
}
