resource "aws_key_pair" "ec2_key" {
  key_name   = "my_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjFdQD+2h71eBoFGTnCc+qVYOduiibYB6g8960Zn9Hku6U1av7Vk7uiWNxXm15yt7pfxcgSwTJRYcx9vOsq0piFGcFhhzk4zdgqlfEFTdUNPhzr4QSV2WUH+32Gg+MrbT98KMQXodzSaDtosidR+oZ8OCQvehGHrHdoksGu2V2AdIZ3ELYdDOyZbH59EOOdUHH+5gUIweonbGhedhAbf3CgHLZO8O+CCsmb93S+PiP0bM4u3nonm/cKtxrzTswvwiZIyMkJ0yUw2tsRBTSAD2xolIAFGlHxPs1Z49zPJ37UAaM5t2eiFjneFkxFFJrofFx+qvsCTKRH8u3elYv98GpXOlgplZqalJs2ft9EPfagL1kz9SXCUAE9JQzC6mHPRZ+NpGz4FgcXQxyunLy/HzvcDPLOJddYPslUxjlpeC5XLa30EcqmXDCCMeOEycNpuKddZxuedYQyloYbrbEEzWhgq11PLyTikhSot1kbrtb2e+2VZLVBjlQkF60kX+s3LE= ghrfhdg@DESKTOP-FOB5C10"
}

resource "aws_iam_role" "example" {
  name = "example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy" "example" {
  name = "example-policy"
  role = aws_iam_role.example.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ],
        Effect = "Allow",
        Resource = "arn:aws:s3:::learn-terraform-mybucket/*",
      },
    ],
  })
}

# NAT EC2 1 인스턴스 생성
resource "aws_instance" "nat_1" {
  ami                    = "ami-0c2d3e23e757b5d84"  # AWS 리전에 따라 적절한 AMI ID로 변경하세요.
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.publict-sub-1.id
  private_ip             = "10.1.1.100"
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
  private_ip             = "10.1.2.100"
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
  private_ip             = "10.1.3.100"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.ec2_key.key_name
  iam_instance_profile = aws_iam_instance_profile.example.name

  # EC2 인스턴스 시작 시 실행될 사용자 데이터 스크립트
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd aws-cli
              sudo systemctl start httpd
              sudo systemctl enable --now httpd
              aws s3 cp s3://${aws_s3_bucket.learn-terraform-mybucket.id}/index.html /var/www/html/index.html
              aws s3 cp s3://${aws_s3_bucket.learn-terraform-mybucket.id}/product1.html /var/www/html/product1.html
              aws s3 cp s3://${aws_s3_bucket.learn-terraform-mybucket.id}/styles.css /var/www/html/styles.css
              sudo systemctl restart httpd
              EOF

  tags = {
    Name = "terraform-web-1"
  }
}

# WEB EC2 2 인스턴스 생성
resource "aws_instance" "web_2" {
  ami                    = "ami-0fd54cba47d6e98dc"  # AWS 리전에 따라 적절한 AMI ID로 변경하세요.
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-sub-2.id
  private_ip             = "10.1.4.100"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.ec2_key.key_name
  iam_instance_profile = aws_iam_instance_profile.example.name

  # EC2 인스턴스 시작 시 실행될 사용자 데이터 스크립트
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd aws-cli
              sudo systemctl start httpd
              sudo systemctl enable --now httpd
              aws s3 cp s3://${aws_s3_bucket.learn-terraform-mybucket.id}/index.html /var/www/html/index.html
              aws s3 cp s3://${aws_s3_bucket.learn-terraform-mybucket.id}/product1.html /var/www/html/product1.html
              aws s3 cp s3://${aws_s3_bucket.learn-terraform-mybucket.id}/styles.css /var/www/html/styles.css
              sudo systemctl restart httpd
              EOF

  tags = {
    Name = "terraform-web-1"
  }
}

resource "aws_iam_instance_profile" "example" {
  name = "Terraform-IAM"
  role = aws_iam_role.example.name
}
