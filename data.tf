data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ami" {
  name_regex = "al2023-ami-2023.1.20230912.0-kernel-6.1-x86_64"
  owner		 = "amazon"
}

data "aws_security_group" "fe_security_id" {
  filter {
    name   = "tag:Name"
    values = ["Tokyo Frontend Security Group"] # insert value here
  }
}

data "aws_security_group" "be_security_id" {
  filter {
    name   = "tag:Name"
    values = ["Tokyo Backend Security Group"] # insert value here
  }
}

data "aws_subnet" "fe_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Tokyo-Frontend-Subnet"] # insert value here
  }
}

data "aws_subnet" "be_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Tokyo-Frontend-Subnet"] # insert value here
  }
}