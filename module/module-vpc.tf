module "vpc" {
  source = "../."

cidr            = "${var.cidr}"

project         = "${var.project}"
environment     = "${var.environment}"

azs             = "${var.azs}"
public-subnets  = "${var.public-subnets}"
private-subnets = "${var.private-subnets}"

}
