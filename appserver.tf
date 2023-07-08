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