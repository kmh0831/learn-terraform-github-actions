provider "aws" {
  region     = "ap-northeast-2"
}

resource "aws_instance" "cicd" {
  ami           = "ami-03221589fd7c8f183"
  instance_type = "t3.micro"
  key_name = aws_key_pair.cicd_make_keypair.key_name  
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  subnet_id = aws_subnet.cicd_subnet.id
  # availability_zone = "ap-northeast-2a"
  associate_public_ip_address = true

  tags = {
    Name = "cicd"
  }
}