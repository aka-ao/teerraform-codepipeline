resource "aws_ecr_repository" "test_codepipeline" {
  name                 = "test_codepipeline"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_url" {
  value = aws_ecr_repository.test_codepipeline.repository_url
}