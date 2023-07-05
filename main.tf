terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}


provider "aws" {
  profile = "terraform"
  region = "ap-northeast-1"
}

resource "aws_instance" "hello-terraform" {
  ami = "ami-0cfc97bf81f2eadc4"
  instance_type = "t2.micro"
  subnet_id = "subnet-0cff88690a3299bc2"

  tags = {
    Name = "Hello Terraform"
  }

  # Nginx
  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
}
