data "aws_ami" "self_ami" {
  most_recent      = true 
  owners           = ["self"]

  filter {
    name   = "state"
    values = ["available"]
  }
}