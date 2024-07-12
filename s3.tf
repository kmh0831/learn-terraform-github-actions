provider "aws" {
  region = "ap-northeast-2"
}

# S3 버킷 생성
resource "aws_s3_bucket" "website_bucket" {
  bucket = "s3-website_bucket-kmhyuk1018-1"  # 버킷 이름을 원하는 이름으로 변경하세요.
  tags = {
    environment = "devel"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  
  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]
  
  policy = <<EOF
  {
      "Version": "2012-10-17", 
      "Statement": [ 
        { 
          "Sid": "Statement1", 
          "Effect": "Allow", 
          "Principal": "*", 
          "Action": "s3:GetObject", 
          "Resource": "${aws_s3_bucket.website_bucket.arn}/*" 
        }
      ]
    }
  EOF
}


resource "aws_s3_object" "app-code-files" {
    for_each = fileset("C:/Users/ghrfhdg/Desktop/WEB/", "**")
        # fileset : 지정 경로에 대한 파일 이름 집합 열거
            # ** : fileset 함수에서 재귀 검색 패턴 적용
            # * : 재귀 검색 없이 단일 검색 패턴으로 적용 시 폴더는 업로드 되지 않음
        # for_each : fileset 함수에서 반환된 문서에 대한 반복을 수행하는 인수

    bucket = aws_s3_bucket.website_bucket.id
        # 업로드 할 Bucket 지정
            # .id 를 통해 생성하기로 한 버킷에 대한 자동 인식
    key = each.value
        # key = bucket에 업로드 시, 지정되는 객체의 이름
            # each.value : 업로드 할 각 파일(폴더)명을 그대로 식별하도록 지정
    source = "C:/Users/ghrfhdg/Desktop/WEB/${each.value}"
        # 업로드 대상에 대한 출처(경로) 지정 및 내부 파일(폴더)들을 각각 지정
}
