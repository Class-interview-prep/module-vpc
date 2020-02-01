output "vpc-id" {
  value = "${module.vpc.vpc-id}"
}

output "vpc-cidr" {
  value = "${module.vpc.vpc-cidr}"
}

output "public-subnets" {
  value = "${module.vpc.public-subnets}"
}

output "private-subnets" {
  value = "${module.vpc.private-subnets}"
}