
resource "aws_vpc" "aws-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "aws-vpc"
  }

}



resource "aws_eip" "vpc-static-up" {
  tags = {
    Name = "aws-vpc-static-up"
  }
  vpc = true
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name = "aws-igw"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.public_subnets
  availability_zone       = var.regionA
  map_public_ip_on_launch = true
  tags = {
    Name = "aws-public-subnet"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.public_subnets2
  availability_zone       = var.regionA2
  map_public_ip_on_launch = true
  tags = {
    Name = "aws-public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.private_subnets
  availability_zone       = var.regionB
  map_public_ip_on_launch = false
  tags = {
    Name = "aws-private-subnet"
  }
}

resource "aws_subnet" "rds-private-subnetA" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = var.private_subnets_dbA
  availability_zone = var.regionB
  tags = {
    Name = "rds-private-subnetA"
  }
}

resource "aws_subnet" "rds-private-subnetB" {
  vpc_id            = aws_vpc.aws-vpc.id
  cidr_block        = var.private_subnets_dbB
  availability_zone = var.regionB2
  tags = {
    Name = "rds-private-subnetB"
  }
}
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.aws-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw.id
  }
  tags = {
    Name = "aws-public-route-table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.aws-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "aws_private-route-table"
  }
}

resource "aws_route_table" "rds-private-subnetA" {
  vpc_id = aws_vpc.aws-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "aws_rds-private-subnetB"
  }
}
resource "aws_route_table" "rds-private-subnetB" {
  vpc_id = aws_vpc.aws-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "aws_rds-private-subnetA"
  }
}
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "PrivateRTassociationRDSA" {
  subnet_id      = aws_subnet.rds-private-subnetA.id
  route_table_id = aws_route_table.rds-private-subnetA.id
}

resource "aws_route_table_association" "PrivateRTassociationRDSB" {
  subnet_id      = aws_subnet.rds-private-subnetB.id
  route_table_id = aws_route_table.rds-private-subnetB.id
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "${var.company}-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.rds-private-subnetA.id, aws_subnet.rds-private-subnetB.id]
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.vpc-static-up.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "aws_nat_gateway"
  }
}

resource "aws_security_group" "ssh-access-sg" {
  description = "Allow SSH access"
  vpc_id      = aws_vpc.aws-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = join("-", ["ssh-access-sg", var.company])
  }
}
resource "aws_security_group" "http-access-sg" {
  description = "Allow HTTP/HTTPS access"
  vpc_id      = aws_vpc.aws-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = join("-", ["http-access-sg", var.company])
  }
}

resource "aws_security_group" "internal-access-sg" {
  name        = "internal-access-sg"
  description = "Allow internal access"
  vpc_id      = aws_vpc.aws-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.http-access-sg.id}",
    ]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.http-access-sg.id}",
    ]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.ssh-access-sg.id}",
    ]
  }
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = true
  }
  tags = {
    Name = join("-", ["http-access-sg", var.company])
  }
}
