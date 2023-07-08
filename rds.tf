# Parameter Group
resource "aws_db_parameter_group" "mysql_standalone_parameter_group" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# Option Group
resource "aws_db_option_group" "mysql_standalone_option_group" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# Subnet Group
resource "aws_db_subnet_group" "mysql_standalone_subnet_group" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
  tags = {
    Name        = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
    Project     = var.project
    Environment = var.environment
  }
}

# RDS Instance
# tfstateにDBのパスワードが残ってしまうため、パスワードだけはapply後に手動で変更するのが望ましい。（もしくはアクセス権制御）
# その際、Lifecycleのignore_changesを使うと良い。
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  # 基本情報
  identifier = "${var.project}-${var.environment}-mysql-standalone"
  username   = "admin"
  password   = random_string.db_password.result
  # DBのスペック
  engine                = "mysql"
  engine_version        = "8.0.33"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false
  # ネットワーク
  multi_az               = false
  availability_zone      = "ap-northeast-1a" # マルチAZではない場合に指定する
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306
  # DBの設定
  name                 = "playground"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parameter_group.name
  option_group_name    = aws_db_option_group.mysql_standalone_option_group.name
  # バックアップ
  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00" # バックアップの後で行うことで安全性を確保する
  auto_minor_version_upgrade = false
  # 削除時の設定
  deletion_protection = true
  skip_final_snapshot = true
  apply_immediately   = true
  # タグ
  tags = {
    Name        = "${var.project}-${var.environment}-mysql-standalone"
    Project     = var.project
    Environment = var.environment
  }
}