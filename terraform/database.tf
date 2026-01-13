# aws rds parameter group
resource "aws_db_parameter_group" "strapi_pg" {
  name   = "strapi-postgres15"
  family = "postgres15"

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "0"
  }

  parameter {
    name  = "statement_timeout"
    value = "0"
  }

  parameter {
    name  = "tcp_keepalives_idle"
    value = "60"
  }

  parameter {
    name  = "tcp_keepalives_interval"
    value = "30"
  }

  parameter {
    name  = "tcp_keepalives_count"
    value = "10"
  }
}


# aws db subnet group
resource "aws_db_subnet_group" "strapi_db_subnet" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "${var.env}-rds-subnet-group"
    Environment = var.env
  }
}

resource "aws_db_instance" "strapi" {
  identifier              = "${var.env}-strapi-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = "strapi"
  username                = "strapi"
  password                = "StrapiPassword123!"
  port                    = 5432

  publicly_accessible     = true
  skip_final_snapshot     = true

  vpc_security_group_ids  = [aws_security_group.strapi_sg2.id]
  parameter_group_name = aws_db_parameter_group.strapi_pg.name

}