provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "learn-terraform-mybucket" {
  bucket = "s3-kmhyuk0831-01"

  tags = {
    environment = "devel"
  }
}

resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.learn-terraform-mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.learn-terraform-mybucket.id
  key    = "index.html"
  source = "index.html"
}

resource "aws_s3_object" "product1_html" {
  bucket = aws_s3_bucket.learn-terraform-mybucket.id
  key    = "product1.html"
  source = "product1.html"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.learn-terraform-mybucket.id
  key    = "styles.css"
  source = "styles.css"
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.learn-terraform-mybucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.public-access
  ]

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.learn-terraform-mybucket.id}/*"]
    }
  ]
}
POLICY
}