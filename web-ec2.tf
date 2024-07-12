resource "aws_key_pair" "ec2_key" {
  key_name   = "my_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjFdQD+2h71eBoFGTnCc+qVYOduiibYB6g8960Zn9Hku6U1av7Vk7uiWNxXm15yt7pfxcgSwTJRYcx9vOsq0piFGcFhhzk4zdgqlfEFTdUNPhzr4QSV2WUH+32Gg+MrbT98KMQXodzSaDtosidR+oZ8OCQvehGHrHdoksGu2V2AdIZ3ELYdDOyZbH59EOOdUHH+5gUIweonbGhedhAbf3CgHLZO8O+CCsmb93S+PiP0bM4u3nonm/cKtxrzTswvwiZIyMkJ0yUw2tsRBTSAD2xolIAFGlHxPs1Z49zPJ37UAaM5t2eiFjneFkxFFJrofFx+qvsCTKRH8u3elYv98GpXOlgplZqalJs2ft9EPfagL1kz9SXCUAE9JQzC6mHPRZ+NpGz4FgcXQxyunLy/HzvcDPLOJddYPslUxjlpeC5XLa30EcqmXDCCMeOEycNpuKddZxuedYQyloYbrbEEzWhgq11PLyTikhSot1kbrtb2e+2VZLVBjlQkF60kX+s3LE= ghrfhdg@DESKTOP-FOB5C10"
}

# NAT EC2 1 인스턴스 생성
resource "aws_instance" "nat_1" {
  ami                    = "ami-0c2d3e23e757b5d84"  # AWS 리전에 따라 적절한 AMI ID로 변경하세요.
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.publict-sub-1.id
  private_ip             = ["10.1.1.100"]
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.ec2_key.key_name
  source_dest_check = false

  tags = {
    Name = "terraform-nat-1"
  }
}

# NAT EC2 1 인스턴스 생성
resource "aws_instance" "nat_2" {
  ami                    = "ami-0c2d3e23e757b5d84"  # AWS 리전에 따라 적절한 AMI ID로 변경하세요.
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.publict-sub-2.id
  private_ip             = ["10.1.2.100"]
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.ec2_key.key_name
  source_dest_check = false

  tags = {
    Name = "terraform-nat-2"
  }
}

# WEB EC2 1 인스턴스 생성
resource "aws_instance" "web_1" {
  ami                    = "ami-0fd54cba47d6e98dc"  # AWS 리전에 따라 적절한 AMI ID로 변경하세요.
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-sub-1.id
  private_ip             = ["10.1.3.100"]
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.ec2_key.key_name

  # EC2 인스턴스 시작 시 실행될 사용자 데이터 스크립트
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx aws-cli
              sudo systemctl start nginx
              sudo systemctl enable --now nginx
              aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/index.html /usr/share/nginx/html/index.html
              aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/product1.html /usr/share/nginx/html/product1.html
              aws s3 cp s3://${aws_s3_bucket.website_bucket.id}/styles.css /usr/share/nginx/html/styles.css
              EOF

  tags = {
    Name = "terraform-web-1"
  }
}

output "public_ip" {
  value = aws_instance.web_1.public_ip
}

# WEB EC2 2 인스턴스 생성
resource "aws_instance" "web_2" {
  ami                    = "ami-0fd54cba47d6e98dc"  # AWS 리전에 따라 적절한 AMI ID로 변경하세요.
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-sub-2.id
  private_ip             = ["10.1.4.100"]
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.ec2_key.key_name

  # EC2 인스턴스 시작 시 실행될 사용자 데이터 스크립트
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx aws-cli
              sudo systemctl start nginx
              sudo systemctl enable --now nginx
              aws s3 cp s3://${aws_s3_bucket.website_bucket.bucket}/index.html /usr/share/nginx/html/index.html
              aws s3 cp s3://${aws_s3_bucket.website_bucket.bucket}/product1.html /usr/share/nginx/html/product1.html
              aws s3 cp s3://${aws_s3_bucket.website_bucket.bucket}/styles.css /usr/share/nginx/html/styles.css
              EOF

  tags = {
    Name = "terraform-web-1"
  }
}

output "public_ip" {
  value = aws_instance.web_2.public_ip
}