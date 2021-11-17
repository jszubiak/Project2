//////////////////////////////////////////////////////////

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

///////////////////////////////////////////////////////////

resource "aws_vpc" "jms-vpc" {
  cidr_block = "10.10.0.0/16"

  tags = var.project_tags
}

///////////////////////////////////////////////////////////

resource "aws_subnet" "jms-subnet" {
  vpc_id            = aws_vpc.jms-vpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-west-1a"

  tags = var.project_tags
}

///////////////////////////////////////////////////////////

resource "aws_internet_gateway" "jms-ig" {
  vpc_id = aws_vpc.jms-vpc.id

  tags = var.project_tags
}

///////////////////////////////////////////////////////////

resource "aws_route_table" "jms-rt" {
  vpc_id = aws_vpc.jms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jms-ig.id
  }

  tags = var.project_tags
}

///////////////////////////////////////////////////////////

resource "aws_route_table_association" "jms-association" {
  subnet_id      = aws_subnet.jms-subnet.id
  route_table_id = aws_route_table.jms-rt.id
}

///////////////////////////////////////////////////////////

resource "aws_security_group" "jsm-sg" {
  name        = "Allow_web_ssh_traffic"
  description = "Allow Web and SSH inbound traffic"
  vpc_id      = aws_vpc.jms-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.project_tags
}

resource "aws_network_interface" "eth0" {
  subnet_id       = aws_subnet.jms-subnet.id
  private_ips     = ["10.10.1.200"]
  security_groups = [aws_security_group.jsm-sg.id]
  tags            = var.project_tags
}

resource "aws_eip" "out" {
  vpc                       = true
  network_interface         = aws_network_interface.eth0.id
  associate_with_private_ip = "10.10.1.200"
  depends_on                = [aws_internet_gateway.jms-ig]
  tags                      = var.project_tags
}

# output "server_public_ip" {
#   value = aws_eip.one.public_ip
# }

resource "aws_instance" "jms-instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = var.key

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eth0.id
  }

  user_data = var.user_data
  tags      = var.project_tags
}
