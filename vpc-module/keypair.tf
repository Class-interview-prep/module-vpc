resource "aws_key_pair" "deployer22" { 
  key_name   = "deployer" 
  public_key = file("~/.ssh/id_rsa.pub")
} 