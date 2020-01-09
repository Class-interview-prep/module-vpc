resource "aws_vpc" "vpc" {
  cidr_block       = "${var.cidr}"
  enable_dns_hostnames = "true"

  tags = {
    Name        = "${var.environment}-${var.name}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.azs)}"
  availability_zone       = "${element(var.azs,count.index)}"
  cidr_block              = "${element(var.public_subnets,count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.environment}-Public_Subnet-${count.index+1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.azs)}"
  availability_zone       = "${element(var.azs,count.index)}"
  cidr_block              = "${element(var.private_subnets,count.index)}"
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.environment}-Private_Subnet-${count.index+1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.environment}-Internet_Gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "${aws_internet_gateway.igw.id}"
  }
    tags = {
    Name = "${var.environment}-Public_Route_Table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${aws_subnet.public_subnets[count.index].id}"
  count          = "${length(var.azs)}"
}

resource "aws_eip" "eip" {
  vpc      = true

  tags = {
    Name = "${var.environment}-Elastic_IP"
  }
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = "${aws_subnet.public_subnets[0].id}"
  allocation_id = "${aws_eip.eip.id}"

  tags = {
    Name = "${var.environment}-Nat_Gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }
    tags = {
    Name = "${var.environment}-Private_Route_Table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  route_table_id = "${aws_route_table.private_route_table.id}"
  subnet_id      = "${aws_subnet.private_subnets[count.index].id}"
  count          = "${length(var.azs)}"
}
