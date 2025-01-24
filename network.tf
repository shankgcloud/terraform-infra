resource "aws_vpc" "MyVPC2" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC2"
  }
}

resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.MyVPC2.id

  tags = {
    Name = "MyIGW"
  }
}

resource "aws_subnet" "PublicSubnet" {
  vpc_id                  = aws_vpc.MyVPC2.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = var.az        # want the public subnet to be in ap-south-1a AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.MyVPC2.id

  route {
    # route to the IGW to have internet access
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }

  # leveraging the depends_on meta-arg here so that the route table is created after the IGW. Else may cause issues or create a blackhole.
  depends_on = [aws_internet_gateway.MyIGW]

  tags = {
    Name = "PublicRoute"
  }
}

resource "aws_route_table_association" "PublicRouteAssociation" {
  # Associating PublicRouteTable to PublicSubnet
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRouteTable.id
}
