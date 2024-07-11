resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.cicd_vpc.id
  
  tags = {
    Name = "cicd-igw"
  }
}

resource "aws_route_table" "cicd_rt" {
  vpc_id = aws_vpc.cicd_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_igw.id
  }
  
  tags = {
    Name = "cicd-rt"
  }
}

resource "aws_route_table_association" "cicd_rta" {
  subnet_id      = aws_subnet.cicd_subnet.id
  route_table_id = aws_route_table.cicd_rt.id
}
