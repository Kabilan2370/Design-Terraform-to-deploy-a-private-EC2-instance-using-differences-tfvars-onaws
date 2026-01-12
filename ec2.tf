
resource "aws_instance" "app" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = file("userData.sh")

  root_block_device {
    volume_size = 20        # 20 GB storage
    volume_type = "gp3"     # Recommended (cost-effective & performant)
    delete_on_termination = true
  }

  tags = {
    Name = "${var.env}-strapi"
  }
}
