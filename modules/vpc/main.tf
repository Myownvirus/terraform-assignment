resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "tf-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block               = var.public_subnet_cidr
  availability_zone        = var.az
  map_public_ip_on_launch  = true
  tags = { Name = "tf-public-subnet" }
}

resource "aws_subnet" "private" {
  vpc_id           = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az
  tags = { Name = "tf-private-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
