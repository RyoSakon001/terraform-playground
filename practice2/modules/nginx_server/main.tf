resource "aws_instance" "server" {
  ami = "ami.0992fc94ca0f1415a"
  instance_type = var.instance_type
  tags = {
    Name = "TestWebServer"
  }
  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1.12
systemctl start nginx
EOF
}