terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC & Networking (keep in root for simplicity)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "strapi-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "strapi-public-${count.index + 1}" }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = { Name = "strapi-private-${count.index + 1}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "strapi-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "strapi-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Modules
module "key_pair" {
  source     = "./modules/key_pair"
  public_key = var.public_key
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  my_ip  = var.my_ip
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu

    mkdir -p /srv/strapi-app
    chown ubuntu:ubuntu /srv/strapi-app

    docker run -d \
      --name strapi \
      -p 1337:1337 \
      -v /srv/strapi-app:/srv/app \
      strapi/strapi
  EOF
}

module "ec2" {
  source        = "./modules/ec2"
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.instance_types[var.env]
  volume_size   = var.root_volume_size

  subnet_id = aws_subnet.private[0].id # <--- use root subnet
  sg_id     = module.security_groups.ec2_sg_id
  key_name  = module.key_pair.key_name
  user_data = local.user_data
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = aws_vpc.main.id                     # <--- use root VPC
  public_subnets  = [for s in aws_subnet.public : s.id] # <--- use root subnets
  alb_sg_id       = module.security_groups.alb_sg_id
  target_instance = module.ec2.instance_id
  target_port     = 1337
}