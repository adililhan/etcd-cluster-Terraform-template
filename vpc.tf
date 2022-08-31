resource "aws_vpc" "etcd-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "etcd-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.etcd-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "etcd public subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.etcd-vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.etcd-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


