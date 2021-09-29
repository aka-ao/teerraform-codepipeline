resource "aws_codebuild_project" "test_codepipeline" {
  name         = "test_codepipeline"
  service_role = aws_iam_role.codebuild_execution_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_CUSTOM_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "181804339651"
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "ap-northeast-1"
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "test_codepipeline"
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
      type  = "PLAINTEXT"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = aws_cloudwatch_log_group.test_codepipeline.name
    }
    s3_logs {
      status = "DISABLED"
    }
  }
}


resource "aws_cloudwatch_log_group" "test_codepipeline" {
  name = "/ecs/test_codepipeline"
}