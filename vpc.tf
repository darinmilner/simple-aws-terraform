
//vpc
resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

//gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id //VPC ID
}

//Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id //VPC ID
  cidr_block        = "10.1.1.0/24"   //Fits inside the VPC
  availability_zone = "ap-northeast-1a"
}

resource "aws_route_table" "default-rt" {
  vpc_id = aws_vpc.main.id

  //route block
  route {
    //allowed routes (open)
    cidr_block = "0.0.0.0/0"
    //where the traffic is going 
    gateway_id = aws_internet_gateway.main.id
  }
}

//Associates route table to the subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.default-rt.id
}

resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "-1" //All protocols
    rule_no    = 100
    action     = "allow"
    cidr_block = var.cidr-block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1" //All protocols
    rule_no    = 200
    action     = "allow"
    cidr_block = var.cidr-block
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_security_group" "allowall" {
  name        = "allow-all-security-group"
  description = "Allows all traffic"
  vpc_id      = aws_vpc.main.id

  //allows SSH
  ingress {
    cidr_blocks = var.open-cidr-blocks
    description = "Allow SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = var.open-cidr-blocks
    description = "Allow all outbound traffic"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 0
  }
}
