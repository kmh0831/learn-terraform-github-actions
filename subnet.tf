resource "aws_subnet" "publict-sub-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  # 이 부분 때문에 public ip가 부여 된다.
  
  tags = {
    Name = "publict-sub-1"
  }
}

resource "aws_subnet" "publict-sub-2" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true
  # 이 부분 때문에 public ip가 부여 된다.
  
  tags = {
    Name = "publict-sub-2"
  }
}

resource "aws_subnet" "private-sub-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.1.3.0/24"
  availability_zone = "ap-northeast-2a"
  # pri이기 떄문에 pub과 다르게 이부분이 없다.
  
  tags = {
    Name = "private-sub-1"
  }
}

resource "aws_subnet" "private-sub-2" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.1.4.0/24"
  availability_zone = "ap-northeast-2c"
  
  tags = {
    Name = "private-sub-2"
  }
}
