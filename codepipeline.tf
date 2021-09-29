resource "aws_codepipeline" "test_codepipeline" {
  name     = "test_codepipeline"
  role_arn = aws_iam_role.codepipeline.arn
  artifact_store {
    location = aws_s3_bucket.pipeline.id
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      run_order        = 1
      output_artifacts = ["source_output"]
      configuration = {
        Owner                = "aka-ao"
        Repo                 = "cicd-demo-app"
        Branch               = "main"
        OAuthToken           = var.github_token
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      run_order        = 2
      configuration = {
        ProjectName = aws_codebuild_project.test_codepipeline.name
      }
    }
  }

//  stage {
//    name = "Deploy"
//    action {
//      category = "Deploy"
//      name = "Deploy"
//      owner = "AWS"
//      provider = "CodeDeployToECS"
//      version = "1"
//      run_order = 3
//      input_artifacts = ["build_output"]
//      configuration = {
//        ApplicationName = aws_codedeploy_app.app.name
//        DeploymentGroupName = aws_codedeploy_deployment_group.group.deployment_group_name
//        TaskDefinitionTemplateArtifact = "build_output"
//        AppSpecTemplateArtifact = "build_output"
//        Image1ArtifactName = "build_output"
//        Image1ContainerName = "IMAGE1_NAME"
//      }
//    }
//  }
}