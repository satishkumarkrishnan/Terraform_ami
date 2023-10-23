## To Create EC2 instance using predefined AMI using data block written inside sub module 
resource "aws_instance" "tokyo-backend" {
  ami             = data.aws_ami.self_ami.id
  instance_type   = "t2.micro"
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "Ec2_created_by_privateAMI"    
  }
}

module "self_owned_ami" { 
         source = "../"        
      }

# To create a EC2 instance using module ami 
resource "aws_instance" "tokyo-private-ami" {
  ami             = module.self_owned_ami.ami_private_id
  instance_type   = "t2.micro"
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "EC2_created_using_module"    
  }
}