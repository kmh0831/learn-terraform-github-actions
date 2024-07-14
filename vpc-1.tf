resource "aws_vpc" "vpc-1" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "vpc-1"
  }
}

# 인터넷 게이트 웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "vpc-1-igw"
  }
}
