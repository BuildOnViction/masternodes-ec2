provider "aws" {
  region = "ap-southeast-1"

  #alias = "singapore"
}

## Singapore state
terraform {
  backend "s3" {
    bucket = "terraform-state-tomo"
    key    = "network/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

#########################################################################
# Data sources to get VPC, subnet, security group and AMI details details
#########################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_availability_zones" "azs" {}

############################################################
# VPC module for all network in Singapore
############################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "tomochain-vpc-singapore"
  cidr   = "10.20.0.0/16"

  azs             = ["${element(data.aws_availability_zones.azs.names, 0)}", "${element(data.aws_availability_zones.azs.names, 1)}", "${element(data.aws_availability_zones.azs.names, 2)}"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]

  assign_generated_ipv6_cidr_block = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "tomo"
    Environment = "testnet"
  }

  vpc_tags = {
    Name = "vpc-tomochain-testnet"
  }
}

######################################
### Getting latest Ubuntu AMI id
######################################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] #  Canonical Owner Code
}

########## SSH SG
module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.9.0"

  name        = "tomochain-ssh"
  description = "Security group which is used as an argrument for ssh access"
  vpc_id      = "${data.aws_vpc.default.id}"

  tags = {
    Name = "tomochain-ssh"
  }

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}

########### MASTERNODE SG
module "masternode_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.9.0"

  name        = "tomochain-masternode"
  description = "Security group which is used for masternode"
  vpc_id      = "${data.aws_vpc.default.id}"

  tags = {
    Name = "tomochain-masternode"
  }

  ingress_with_cidr_blocks = [
    {
      from_port   = 30303
      to_port     = 30303
      protocol    = "tcp"
      description = "Service port (ipv4) tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Open to IPV6 CIDR blocks (rule or from_port+to_port+protocol+description)
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 30303
      to_port          = 30303
      protocol         = "tcp"
      description      = "Service ports (ipv6) tcp"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 30303
      to_port     = 30303
      protocol    = "udp"
      description = "Service port (ipv4) tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Open to IPV6 CIDR blocks (rule or from_port+to_port+protocol+description)
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 30303
      to_port          = 30303
      protocol         = "udp"
      description      = "Service ports (ipv6) tcp"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  egress_rules = ["all-all"]
}

############### BOOTNODE SG
module "bootnode_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.9.0"

  name        = "tomochain-bootnode"
  description = "Security group which is used for masternode"
  vpc_id      = "${data.aws_vpc.default.id}"

  tags = {
    Name = "tomochain-bootnode"
  }

  ingress_with_cidr_blocks = [
    {
      from_port   = 30301
      to_port     = 30301
      protocol    = "tcp"
      description = "Service port (ipv4) tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Open to IPV6 CIDR blocks (rule or from_port+to_port+protocol+description)
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 30301
      to_port          = 30301
      protocol         = "tcp"
      description      = "Service ports (ipv6) tcp"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 30301
      to_port     = 30301
      protocol    = "udp"
      description = "Service port (ipv4) tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Open to IPV6 CIDR blocks (rule or from_port+to_port+protocol+description)
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 30301
      to_port          = 30301
      protocol         = "udp"
      description      = "Service ports (ipv6) tcp"
      ipv6_cidr_blocks = "::/0"
    },
  ]

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  egress_rules = ["all-all"]
}

######### TESTNET SG
module "testnet_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.9.0"

  name        = "tomochain-testnet"
  description = "Security group which is used for masternode"
  vpc_id      = "${data.aws_vpc.default.id}"

  tags = {
    Name = "tomochain-testnet"
  }

  # Open for self (rule or from_port+to_port+protocol+description)
  ingress_with_self = [
    {
      rule = "all-all"
      self = true
    },
  ]

  # Open for self (rule or from_port+to_port+protocol+description)
  egress_with_self = [
    {
      rule = "all-all"
    },
  ]
}

################# EC2 for Masternode ######################

module "ec2_sun" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.13.0"

  instance_count = 1

  name                        = "masternode-sun"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.xlarge"
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids      = ["${module.masternode_sg.this_security_group_id}", "${module.bootnode_sg.this_security_group_id}", "${module.testnet_sg.this_security_group_id}", "${module.ssh_sg.this_security_group_id}"]
  associate_public_ip_address = true
  cpu_credits                 = "unlimited"

  ## Adding your shells anf environment files
 /*  provisioner "file" {
    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/user-data.sh",
      "/tmp/user-data.sh args",
    ]
  } */
}
