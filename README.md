## Read Me

### Purpose of this module

### this module will create aws vpc with given cidr block
##### multiple public and private subnets with nat

##### copy and paste this to your main.tf and adjust variables according to your needs.

```
module "myvpc" {
  source = "git::https://github.com/hakten/vpc-module.git"
  
  cidr            = "10.0.0.0/16"
  name            = "Wordpress"
  environment     = "Test"

  azs             = ["us-east-1a","us-east-1b","us-east-1c"]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]

  }
  ```
