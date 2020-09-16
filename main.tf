terraform {
  # The configuration for this backend will be filled in by terragrunt
  backend "s3" {
  }
}

terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.43.0"
  region  = var.region
  profile = var.profile
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20200904.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "Public SSH"
  description = "Public SSH Security Group"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}


module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "efs-monitor"
  ami            = data.aws_ami.amazon_linux.id
  instance_type  = "t3.micro"
  key_name       = var.ssh_key
  vpc_security_group_ids = [module.security_group.this_security_group_id]
  subnet_id              = var.subnet_id

}  
