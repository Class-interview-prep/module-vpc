module "vpc" {
  source = "../."

cidr            = "10.0.0.0/16"

project         = "Wordpress"
environment     = "Test"

azs             = ["us-east-1a","us-east-1b","us-east-1c"]
public_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
private_subnets = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]

output "pub-subs" {
  value = "module.vpc.aws_subnet.public_subnets"
}

}