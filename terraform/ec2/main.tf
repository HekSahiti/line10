data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:name"
    values = ["lineten"]
  }
}

resource "aws_security_group" "lineten-sg" {
  name        = "LineTen"
  description = "Lineten security group"
  vpc_id      = data.aws_vpc.default.id

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port   = 5500
    protocol    = "tcp"
    to_port     = 5500
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_eip" "lb" {
#   instance = aws_instance.lineten_instance.id
#   domain   = "vpc"
# }

resource "aws_instance" "lineten_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lineten-sg.id]
  key_name                    = "key-pair"

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt upgrade
    sudo apt install curl
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
    sudo usermod -a -G docker ubuntu
  EOF

  tags = {
    Name = "LineTen Assesment"
  }
}
