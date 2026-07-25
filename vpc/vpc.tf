

resource "aws_vpc" "anywork_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.anywork_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public_subnet-${var.azs[count.index]}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.anywork_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private_subnet-${var.azs[count.index]}"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "anywork_gw" {
  vpc_id = aws_vpc.anywork_vpc.id

  tags = {
    Name = "anywork_gw"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "anywork_route_table" {
  vpc_id = aws_vpc.anywork_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.anywork_gw.id
  }

  route {
    cidr_block = "10.0.2.0/24"
    gateway_id = aws_internet_gateway.anywork_gw.id
  }


  tags = {
    Name = "anywork_route_table"
    ManagedBy = "Terraform"
  }
}

resource "aws_nat_gateway" "anywork_private_nat" {
  subnet_id     = aws_subnet.private_subnet[0].id

  tags = {
    Name = "gw NAT"
    ManagedBy = "Terraform"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.anywork_gw]
}