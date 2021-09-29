resource "aws_s3_bucket" "pipeline" {
  bucket = "testcodepipelineartifact"
  acl    = "private"
}