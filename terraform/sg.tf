# Security group for ALB

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port       = var.strapi_port
    to_port         = var.strapi_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }


  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Database
resource "aws_security_group" "strapi_sg2" {
  name   = "data-sg-for-database"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port      = 5432
    to_port        = 5432
    protocol       = "tcp"
    security_groups    = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port        = 0
    protocol      = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}
