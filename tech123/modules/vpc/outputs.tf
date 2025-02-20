output "name" {
  value = var.project_name
  
}

output "vpc_id" {
  value = aws_vpc.tech123_vpc.id
}


output "public_subnets" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}


output "db_subnets_cidr" {
  value = var.db_subnets_cidr
}

output "igw_id" {
  value = aws_internet_gateway.tech123_igw.id
}

output "availability_zones" {
  value = var.availability_zones
}


