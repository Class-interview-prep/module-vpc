resource "aws_instance" "bastion" {
  instance_type          = "t2.micro"
  ami                    = "ami-02eac2c0129f6376b"
  subnet_id              = module.vpc.aws_subnet.public_subnets[0]
  key_name               = aws_key_pair.deployer22.key_name
  
  #user_data = file("")
  
  tags = {
    Name = "Bastion"
  }
}