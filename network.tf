resource "aws_vpc" "ct-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags = {
    "Name" = "ct-vpc"
  }
}


resource "aws_subnet" "ct-subnet-public" {
  vpc_id                  = aws_vpc.ct-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    "Name" = "ct-subnet-public"
  }
}

resource "aws_subnet" "ct-subnet-private" {
  vpc_id                  = aws_vpc.ct-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1a"
  tags = {
    "Name" = "ct-subnet-private"
  }
}
resource "aws_subnet" "ct-subnet-private2" {
  vpc_id                  = aws_vpc.ct-vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1b"
  tags = {
    "Name" = "ct-subnet-private2"
  }
}

resource "aws_internet_gateway" "ct-igw" {
  vpc_id = aws_vpc.ct-vpc.id
  tags = {
    "Name" = "ct-igw"
  }
}

resource "aws_eip" "ct-nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ct-igw]
  tags = {
    "Name" = "ct-nat_eip"
  }
}

resource "aws_nat_gateway" "ct-nat" {
  allocation_id = aws_eip.ct-nat_eip.id
  subnet_id     = aws_subnet.ct-subnet-public.id
  depends_on = [
    aws_internet_gateway.ct-igw
  ]
  tags = {
    "Name" = "ct-nat"
  }
}


resource "aws_route_table" "ct-public-rt" {
  vpc_id = aws_vpc.ct-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ct-igw.id
  }
  tags = {
    "Name" = "ct-public-rt"
  }
}

resource "aws_route_table" "ct-private-rt" {
  vpc_id = aws_vpc.ct-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ct-nat.id
  }
  tags = {
    "Name" = "ct-private-rt"
  }
}

resource "aws_route_table_association" "ct-rt-public-subnet" {
  subnet_id      = aws_subnet.ct-subnet-public.id
  route_table_id = aws_route_table.ct-public-rt.id
}

resource "aws_route_table_association" "ct-rt-private-subnet" {
  subnet_id      = aws_subnet.ct-subnet-private.id
  route_table_id = aws_route_table.ct-private-rt.id
}


resource "aws_security_group" "ct-db" {
  vpc_id = aws_vpc.ct-vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.ct-subnet-public.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ct-db"
  }
}

resource "aws_security_group" "ct-group" {
  vpc_id = aws_vpc.ct-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ct-group"
  }
}
resource "aws_security_group" "app-group" {
  vpc_id = aws_vpc.ct-vpc.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.ct-subnet-public.cidr_block]
  }
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "app-group"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.ct-subnet-private.id, aws_subnet.ct-subnet-private2.id]
}
