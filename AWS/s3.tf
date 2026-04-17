resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "demo_bucket_versioning" {
  bucket = aws_s3_bucket.demo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "demo_object" {
  bucket = aws_s3_bucket.demo_bucket.id
  key    = "test-file.txt"
  source = "./test-file.txt"
  etag   = filemd5("./test-file.txt")
}