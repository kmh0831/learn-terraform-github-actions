#routing table 생성
resource "aws_route_table" "rt-pub-vpc-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-pub-vpc-1"
  }
}

# pub 라우팅 테이블에 associate 하기
resource "aws_route_table_association" "rt-pub-as1-vpc-10-10-0-0" {
  subnet_id      = aws_subnet.publict-sub-1.id
  route_table_id = aws_route_table.rt-pub-vpc-1.id
}

resource "aws_route_table_association" "rt-pub-as2-vpc-10-10-0-0" {
  subnet_id      = aws_subnet.publict-sub-2.id
  route_table_id = aws_route_table.rt-pub-vpc-1.id
}

# private 서브넷 routing table 생성
resource "aws_route_table" "rt-pri1-vpc-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_1.primary_network_interface_id
  }

  tags = {
    Name = "rt-pri1-vpc-1"
  }

  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "aws_route_table" "rt-pri2-vpc-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_2.primary_network_interface_id
  }

  tags = {
    Name = "rt-pri2-vpc-1"
  }

  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "aws_route_table_association" "rt-pri1-as1-vpc-1" {
  subnet_id      = aws_subnet.private-sub-1.id
  route_table_id = aws_route_table.rt-pri1-vpc-1.id
}

resource "aws_route_table_association" "rt-pri2-as2-vpc-1" {
  subnet_id      = aws_subnet.private-sub-2.id
  route_table_id = aws_route_table.rt-pri2-vpc-1.id
}
