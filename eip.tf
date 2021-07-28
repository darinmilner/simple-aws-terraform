resource "aws_eip" "webserver" {
  instance = aws_instance.webserver.id
  vpc      = true
  depends_on = [
    aws_internet_gateway.main
  ]
}


# resource "aws_key_pair" "default" {
#   key_name   = "ssh-key"
#   public_key = file("public-key/terraform-asia-key.pem")
# }

data "aws_ami" "ubuntu-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
