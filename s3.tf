resource "aws_s3_bucket" "bucket" {
  bucket   = var.bucket_name
  provider = aws.region
  acl      = "public-read"

  website {
    index_document = "index.html"
  }
}