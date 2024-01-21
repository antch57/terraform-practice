resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for rds"
  vpc_id      = var.vpc_id
}

resource "aws_db_instance" "db_instance" {
  engine                              = "mysql"
  engine_version                      = "8.0.35"
  instance_class                      = "db.t2.micro"
  manage_master_user_password         = true
  iam_database_authentication_enabled = false
  skip_final_snapshot                 = true
  allocated_storage                   = "20"
  username                            = "admin"
  publicly_accessible                 = false
  vpc_security_group_ids              = [aws_security_group.rds_sg.id]
}
