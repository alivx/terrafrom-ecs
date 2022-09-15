resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = join("-", [var.company, "db"])
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"

  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.internal-access-sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
}