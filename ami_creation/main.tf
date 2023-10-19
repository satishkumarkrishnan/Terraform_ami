## To Create EC2 instance using predefined AMI
resource "aws_instance" "tokyo-backend" {
  ami             = "ami-0829d5e8a43cd05fa"
  instance_type   = "t2.micro"
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "Ec2_created_by_privateAMI"    
  }
}