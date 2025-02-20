resource "aws_vpc" "tech123_vpc" {
  cidr_block           = var.netw_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name} vpc"
  }
}



# create subnets, 9 in total

# Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.tech123_vpc.id
  count = length(var.public_subnets_cidr)  # Dynamic count based on the length of CIDR list
  cidr_block = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name} public subnet ${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.tech123_vpc.id
  count = length(var.private_subnets_cidr)  # Dynamic count based on the length of CIDR list
  cidr_block = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.project_name} private subnet ${count.index + 1}"
  }
}  

# DB Subnets
resource "aws_subnet" "db_subnets" {
  vpc_id = aws_vpc.tech123_vpc.id
  count = length(var.db_subnets_cidr)  # Dynamic count based on the length of CIDR list
  cidr_block = element(var.db_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.project_name} db subnet ${count.index + 1}"
  }
}

# create route tables
# public route table
resource "aws_route_table" "public_route_table" {
  depends_on = [aws_vpc.tech123_vpc]
  vpc_id = aws_vpc.tech123_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tech123_igw.id
  }

  tags = {
    Name = "${var.project_name} public route table"
  }
}



# private route table
resource "aws_route_table" "private_route_table" {
  depends_on = [ aws_vpc.tech123_vpc ]
  vpc_id = aws_vpc.tech123_vpc.id

  route {
    cidr_block = var.netw_cidr  # Route to the VPC CIDR block
    gateway_id = "local"
  }

  tags = {
  Name = "${var.project_name} private route table"
  }
}

#create database subnets route table
resource "aws_route_table" "db_route_table" {
  depends_on = [ aws_vpc.tech123_vpc ]
  vpc_id = aws_vpc.tech123_vpc.id

  route {
    cidr_block = var.netw_cidr  # Route to the VPC CIDR block
    gateway_id = "local"
  }

  tags = {
  Name = "${var.project_name} db route table"
  }
}

# associate route tables with subnets
# Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

# DB Subnets
resource "aws_route_table_association" "db_subnet_association" {
  count          = length(var.db_subnets_cidr)
  subnet_id      = element(aws_subnet.db_subnets[*].id, count.index)
  route_table_id = aws_route_table.db_route_table.id
}

# create internet gateway
resource "aws_internet_gateway" "tech123_igw" {
  vpc_id = aws_vpc.tech123_vpc.id

  tags = {
    Name = "${var.project_name} igw"
  }
}



