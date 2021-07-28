resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.ubuntu-ami.id
  availability_zone      = "ap-northeast-1a"
  instance_type          = "t2.micro"
  key_name               = "terraform-asia-key"
  vpc_security_group_ids = [aws_security_group.allowall.id]
  subnet_id              = aws_subnet.main.id
}

output "public-ip" {
  value = aws_eip.webserver.public_ip
}

