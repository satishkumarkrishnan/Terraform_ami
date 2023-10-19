output "vpc_id" {
  value = aws_vpc.tokyo-vpc.id
}

output "vpc_fe_subnet" {
  value = aws_subnet.private[0]
}

output "vpc_be_subnet" {
  value = aws_subnet.private[1]
}

output "vpc_ig" {
  value = aws_internet_gateway.tokyo-igw.id
}

output "vpc_rt" {
  value = aws_route_table.tokyo-public-route.id
}

output "vpc_nacl_fe" {
  value = aws_network_acl.tokyo-nacl[0].id
}

output "vpc_nacl_be" {
  value = aws_network_acl.tokyo-nacl[1].id
}

output "vpc_fe_sg" {
  value = aws_security_group.tokyo-securitygroup[0].id
}

output "vpc_be_sg" {
  value = aws_security_group.tokyo-securitygroup[1].id
}

output "ami_arn" {
  value = aws_ami_from_instance.example.arn
}

output "ami_private_id" {
  value = aws_ami_from_instance.example.id
}

output "ami_owner_id" {
  value = aws_ami_from_instance.example.owner_id
}

output "ami_root_snapshot_id" {
  value = aws_ami_from_instance.example.root_snapshot_id
}

output "ami_usage_operation" {
  value = aws_ami_from_instance.example.usage_operation
}

output "ami_platform_details" {
  value = aws_ami_from_instance.example.platform_details
}

output "ami_image_owner_alias" {
  value = aws_ami_from_instance.example.image_owner_alias
}

output "ami_image_type" {
  value = aws_ami_from_instance.example.image_type
}

output "ami_hypervisor" {
  value = aws_ami_from_instance.example.hypervisor
}

output "ami_platform" {
  value = aws_ami_from_instance.example.platform
}

output "ami_public" {
  value = aws_ami_from_instance.example.public
}

output "ami_tags_all" {
  value = aws_ami_from_instance.example.tags_all
}