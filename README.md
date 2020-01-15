## This module will create AWS VPC with the following resources and specifications.

* Multiple public and private subnets will be created, not limited to azs, you can create as many as you want.
* Single internet gateway will be created for public subnets.
* One nat gateway will be created for each availability zone for high availability and fault tolerance.
* Every resource will be tagged with "project" and "environment", so that they can be tracked by monitoring tools.
* Tags will also be used in naming schema. This will make navigating through your resources easier.




#### Copy and paste this to your main.tf and adjust variables according to your needs.

```
module "vpc" {
  source = "git::https://github.com/hakten/module-vpc.git"

cidr            = "10.0.0.0/16"

project         = "Wordpress"
environment     = "Test"

azs             = ["us-east-1a","us-east-1b","us-east-1c"]
public_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
private_subnets = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]

}
  ```
