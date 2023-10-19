## To Create EC2 instance using predefined AMI
resource "aws_instance" "tokyo-frontend" {
  ami             = aws_s3_object.object.content
  instance_type   = "t2.micro"
  tags = {
    Name = "Ec2_created_by_privateAMI"    
  }
}