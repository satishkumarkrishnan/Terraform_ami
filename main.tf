#######################################################
################### Start - AWS VPC ###################
#######################################################
terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

#######################################################
################### Start - AWS VPC ###################
#######################################################

resource "aws_vpc" "tokyo-vpc" {
  cidr_block           = var.vpc_CIDR
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = var.vpc
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "tokyo-igw" {
  vpc_id = aws_vpc.tokyo-vpc.id
  tags = {
    Name = var.internet-gateway
  }
}

# Create Route Tables
resource "aws_route_table" "tokyo-public-route" {
  vpc_id = aws_vpc.tokyo-vpc.id
  tags = {
    Name = var.route-table["public"]
  }
}

# Create Internet route access
resource "aws_route" "tokyo-internet-route" {
  route_table_id         = aws_route_table.tokyo-public-route.id
  destination_cidr_block = var.allIPsCIDRblock
  gateway_id             = aws_internet_gateway.tokyo-igw.id
}

# Create Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet)
  vpc_id                  = aws_vpc.tokyo-vpc.id
  cidr_block              = var.private_subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.mapPublicIP
  tags = {
    Name        = "tokyo-subnets-${count.index}"
  }
}

# Create Network Access Control Lists
resource "aws_network_acl" "tokyo-nacl" {
  count  = length(var.private_subnet)
  vpc_id = aws_vpc.tokyo-vpc.id
  subnet_ids = [aws_subnet.private[count.index].id]
  # allow ingress HTTP from port  80 all IPs
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allIPsCIDRblock
    from_port  = 0
    to_port    = 65535
  }

  # allow egress ephemeral ports to all IPs
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allIPsCIDRblock
    from_port  = 0
    to_port    = 65535
  }
  tags = {
    Name = "tokyo-sg-${count.index}"
  }
}

# Create Security Groups
resource "aws_security_group" "tokyo-securitygroup" {
  count  = 2
  vpc_id = aws_vpc.tokyo-vpc.id

  # allow ingress HTTP from port  80 all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # allow ingress HTTPS port 443 from all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  # allow ingress HTTPS port 22 from all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow egress ephemeral ports to all IPs
  egress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }
  tags = {
    Name = "tokyo-sg-${count.index}"
  }
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "tokyo-rt-association" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.tokyo-public-route.id
}
#####################################################
################### End - AWS VPC ###################
#####################################################
resource "aws_key_pair" "deployer" {
  key_name   = "ec2-key"
  public_key = file("${path.module}/key")
}

## To Create EC2 instance
resource "aws_instance" "tokyo-frontend" {
  ami             = data.aws_ami.ami.id
  instance_type   = "t2.micro"
  security_groups = [data.aws_security_group.fe_security_id.id]
  subnet_id       = data.aws_subnet.fe_subnet.id
  key_name      = "ec2-key"
  user_data     = filebase64("${path.module}/user_data.sh")
  tags = {
    Name = "Web_Server"
    Role = "frontend"
  }
}
#EBS Snapshot Creation
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "terraform_snap"
  }
}
#EBS Volume creation
resource "aws_ebs_volume" "example" {
  availability_zone = "ap-northeast-1a"
  size              = 40
  tags = {
    Name = "terraform_ebs_volume"
  }
}

# AMI Creation
resource "aws_ami" "example" {
  name                = "terraform-ami-POC"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvdb"
  ebs_block_device {
    device_name = "/dev/xvdb"
    snapshot_id = "snap-08a5274c81e20b415"
    volume_size = 40
  }
  tags = {
    Name = "terraform_poc_image"
  }
}