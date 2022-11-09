terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#variable "akin" {
 # description = "I'm replacing the vpc_id with papi  to test variables out"
  #type = list
  #default = [aws_vpc.main.id]
#}

variable "pappy" {

  description = "creating a variable for cidr_block"
  type = string
  default = "10.0.0.0/16"

}

variable "chulo" {
  description = "creating second cidr's variable"
  type = string
  default = "0.0.0.0/0"
}

variable "prixito" {
  description = "creating var for tag name"
  type = string
  default = "mumbai"
}

variable "shamo" {
  description = "var for demoigw"
  type = string
  default = "island"
}

resource "aws_vpc" "main" {
  cidr_block       = var.pappy
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pubsubnet"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.shamo
  }
}

resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.chulo
    gateway_id = aws_internet_gateway.main_igw.id
  }


  tags = {
    Name = var.prixito
  }
}


resource "aws_route_table_association" "main-rt" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main-rt.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
