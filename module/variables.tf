variable "region" {}

variable "cidr" {}
variable "project" {}
variable "environment" {}

variable "azs" {
    type = "list"
}
variable "public-subnets" {
    type = "list"
}
variable "private-subnets" {
    type = "list"
}


