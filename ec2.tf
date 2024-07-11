provider "aws" {
  region     = "ap-northeast-2"
}

resource "aws_instance" "cicd" {
  ami           = "ami-0fd54cba47d6e98dc"
  instance_type = "t2.micro"
  key_name = aws_key_pair.cicd_make_keypair.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "cicd"
  }
}
