
resource "aws_vpc" "this" {

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc-${var.region}-${var.env_code}-${var.project_name}-stack"
  }
}
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_cidr_blocks, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "subnet-${var.region}-${element(data.aws_availability_zones.available.zone_ids, count.index)}-public-${var.env_code}-${var.project_name}-stack"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_cidr_blocks, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "subnet-${var.region}-${element(data.aws_availability_zones.available.zone_ids, count.index)}-private-${var.env_code}-${var.project_name}-stack"
  }
}


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "IGW-${var.env_code}-${var.project_name}"
  }
}

resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "RT-${var.env_code}-${var.project_name}"
  }
}

resource "aws_route_table_association" "igw_rt_assoc" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.igw_rt.id
}

resource "aws_eip" "nat_gateway" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gateway[0].id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = "NGW-${var.env_code}-${var.project_name}"
  }
}


resource "aws_route_table" "nat_rt" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }
}

resource "aws_route_table_association" "nat_rt_assoc" {
  count          = var.create_nat_gateway && length(var.private_cidr_blocks) > 0 ? length(var.private_cidr_blocks) : 0
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.nat_rt[0].id
}
