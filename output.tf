output "vpc-id" {
  value = "${aws_vpc.main.id}"
}

output "vpc-cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "public-subnets" {
  value = "${aws_subnet.public-subnets.*.id}"
}

output "private-subnets" {
  value = "${aws_subnet.private-subnets.*.id}"
}
