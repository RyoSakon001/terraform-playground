# Web Security Group
resource "aws_security_group" "web_sg" {
  name = "${var.project}-${var.environment}-web-sg"
  description = "Web Security Group"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-web-sg"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "http"
  from_port         = 80
  to_port           = 80
  cidr_block = "0.0.0.0/0"
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "https"
  from_port         = 443
  to_port           = 443
  cidr_block = "0.0.0.0/0"
}

resource "aws_security_group_rule" "web_out_tcp3000" {
  security_group_id = aws_security_group.web_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_block = "0.0.0.0/0"
}