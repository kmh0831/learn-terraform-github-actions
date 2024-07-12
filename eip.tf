# EIP 받아오기
resource "aws_eip" "nat-1" {
  instance = aws_instance.web_1.id
  domain   = "vpc"
}

resource "aws_eip" "nat-2" {
  instance = aws_instance.web_1.id
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.nat-1.id
  subnet_id     = aws_subnet.publict-sub-1.id

  tags = {
    Name = "gw NAT-1"
  }
}
resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.nat-2.id
  subnet_id     = aws_subnet.publict-sub-2.id

  tags = {
    Name = "gw NAT-2"
  }
}