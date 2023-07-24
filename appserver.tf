# Key Pair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-keypair"
  public_key = file("${var.public_key_path}")

  tags = {
    Name        = "${var.project}-${var.environment}-keypair"
    Project     = var.project
    Environment = var.environment
  }
}

# EC2 Instance
# resource "aws_instance" "app_server" {
#   # 基本情報
#   ami                         = data.aws_ami.app.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_subnet_1a.id
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
#   # セキュリティ
#   vpc_security_group_ids = [
#     aws_security_group.app_sg.id
#     , aws_security_group.om_sg.id

#   ]
#   key_name = aws_key_pair.keypair.key_name

#   tags = {
#     Name        = "${var.project}-${var.environment}-app-ec2"
#     Project     = var.project
#     Environment = var.environment
#     Type        = "app"
#   }
# }

# Launch Template
resource "aws_launch_template" "app_lt" {
  update_default_version = true
  name                   = "${var.project}-${var.environment}-app-lt"
  image_id               = data.aws_ami.app.id
  key_name               = aws_key_pair.keypair.key_name
  instance_type          = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
    , aws_security_group.om_sg.id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project}-${var.environment}-app-ec2"
      Project     = var.project
      Environment = var.environment
      Type        = "app"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    # subnet_id                   = aws_subnet.public_subnet_1a.id
    security_groups = [
      aws_security_group.app_sg.id,
      aws_security_group.om_sg.id
    ]
    delete_on_termination = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2_profile.name
  }

  user_data = filebase64("./src/initialize.sh")
}