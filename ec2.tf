
resource "aws_instance" "app" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = file("userData.sh")

  tags = {
    Name = "${var.env}-strapi"
  }
}
