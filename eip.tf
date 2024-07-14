# EIP 받아오기
resource "aws_eip" "nat-1" {
  instance = aws_instance.nat_1.id
  domain   = "vpc"
}

resource "aws_eip" "nat-2" {
  instance = aws_instance.nat_2.id
  domain   = "vpc"
}
