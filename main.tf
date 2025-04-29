resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.common_tags,
    var.abc, 
    {
        Name = local.resource_name
    }
  )
  }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.abc, 
    var.igw_tags,
    {
        Name = "${local.resource_name} - igw"
    }
  )
}


resource "aws_subnet" "public" {
  count = length(var.public_cidr_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_subnet[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch  = true

  tags =  merge(
    var.common_tags, 
    var.public_subnet_tags,
    {
        Name ="${local.resource_name} -public- ${local.azs[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_subnet[count.index]
  availability_zone = local.azs[count.index]
  

  tags =  merge(
    var.common_tags, 
    var.private_subnet_tags,
    {
        Name ="${local.resource_name} -private- ${local.azs[count.index]}"
    }
  )
}

resource "aws_eip" "els_nat" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "natgate" {
  allocation_id = aws_eip.els_nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags, 
    var.nat_tags,
    {
        Name ="${local.resource_name} - nat"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags, 
    var.public_route_tags,
    {
        Name ="${local.resource_name} - public_route"
    }
  )
  
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags, 
    var.private_route_tags,
    {
        Name ="${local.resource_name} - private_route"
    }
  )
  
}


resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgate.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count = length(var.private_cidr_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


