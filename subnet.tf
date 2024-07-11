resource "aws_subnet" "cicd_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.cicd_vpc.id
  
  tags = {
    Name = "cicd-subnet"
  }
}