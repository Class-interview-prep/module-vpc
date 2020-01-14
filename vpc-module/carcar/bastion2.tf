resource "aws_instance" "bastion2" {
  instance_type          = "t2.micro"
  ami                    = "ami-02eac2c0129f6376b"
  subnet_id              = "subnet-03a009b4834ccd036"
  key_name               = "deployer"
  
  #user_data = file("")
  
  tags = {
    Name = "Bastion2"
  }
}

output "instance2" {
  value = aws_instance.bastion2.id
}
