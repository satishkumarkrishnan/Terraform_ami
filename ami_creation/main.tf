## To Create EC2 instance using predefined AMI
/*resource "aws_instance" "tokyo-backend" {
  ami             = "${data.aws_ami.self_ami.id}"
  instance_type   = "t2.micro"
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "Ec2_created_by_privateAMI"    
  }
}*/
module self_owned_ami {
        source = "git@github.com:satishkumarkrishnan/Terraform_ami.git?ref=main"
        ami    = "${module.ami.id}"
      }
