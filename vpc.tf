resource "aws_vpc" "main" {
  cidr_block             = "${var.cidr}"
  enable_dns_hostnames   = "true"

  tags = {
    Name            = "${var.environment}-${var.project}"
    Environment     = "${var.environment}"
    Project         = "${var.project}"
  }
}

resource "aws_subnet" "public-subnets" {
  vpc_id                  = "${aws_vpc.main.id}"
  count                   = "${length(var.public-subnets)}"
  availability_zone       = "${element(var.azs,count.index)}"
  cidr_block              = "${element(var.public-subnets,count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    Name              = "${var.environment}-${var.project}-Public-Subnet-${count.index+1}"
    Environment       = "${var.environment}"
    Project           = "${var.project}"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id                  = "${aws_vpc.main.id}"
  count                   = "${length(var.private-subnets)}"
  availability_zone       = "${element(var.azs,count.index)}"
  cidr_block              = "${element(var.private-subnets,count.index)}"
  map_public_ip_on_launch = false
  
  tags = {
    Name                  = "${var.environment}-${var.project}-Private-Subnet-${count.index+1}"
    Environment           = "${var.environment}"
    Project               = "${var.project}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id            = "${aws_vpc.main.id}"

  tags = {
    Name            = "${var.environment}-${var.project}-Internet-Gateway"
    Environment     = "${var.environment}"
    Project         = "${var.project}"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id          = "${aws_vpc.main.id}"

  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id    = "${aws_internet_gateway.igw.id}"
  }
    tags = {
    Name          = "${var.environment}-${var.project}-Public-Route-Table"
    Environment   = "${var.environment}"
    Project       = "${var.project}"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${element(aws_subnet.public-subnets.*.id,count.index)}"
  count          = "${length(var.public-subnets)}"
}

resource "aws_eip" "eip" {
  count          = "${length(var.private-subnets)}"
  vpc            = true

  tags = {
    Name          = "${var.environment}-${var.project}-Elastic-IP-${count.index+1}"
    Environment   = "${var.environment}"
    Project       = "${var.project}"
  }
}

resource "aws_nat_gateway" "nat" {
  count           = "${length(var.private-subnets)}"
  subnet_id       = "${element(aws_subnet.public-subnets.*.id,count.index)}"
  allocation_id   = "${element(aws_eip.eip.*.id,count.index)}"
  

  tags = {
    Name          = "${var.environment}-${var.project}-Nat-Gateway-${count.index+1}"
    Environment   = "${var.environment}"
    Project       = "${var.project}"
  }
}

resource "aws_route_table" "private-route-table" {
  count           = "${length(var.private-subnets)}"
  vpc_id          = "${aws_vpc.main.id}"

  route {
    cidr_block       = "0.0.0.0/0"
    nat_gateway_id   = "${element(aws_nat_gateway.nat.*.id,count.index)}"
  }
    tags = {
    Name             = "${var.environment}-${var.project}-Private-Route-Table-${count.index+1}"
    Environment      = "${var.environment}"
    Project          = "${var.project}"
  }
}

resource "aws_route_table_association" "private-route-table-association" {
  count            = "${length(var.private-subnets)}"
  route_table_id   = "${element(aws_route_table.private_route_table.*.id,count.index)}"
  subnet_id        = "${element(aws_subnet.private-subnets.*.id,count.index)}"
}