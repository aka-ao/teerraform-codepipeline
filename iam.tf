#########################
# CodePipeline IAM
#########################
data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "codepipeline" {
  name               = "ecs-pipeline-project"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json
}

resource "aws_iam_policy" "codepipeline" {
  name        = "ecs-pipeline-codepipeline"
  description = "ecs-pipeline-codepipeline"
  policy = templatefile("${path.root}/assets/codepipeline_policy.tpl", {
    artifacts = aws_s3_bucket.pipeline.id
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.id
  policy_arn = aws_iam_policy.codepipeline.arn
}

#########################
# CodeBuild IAM
#########################
data "aws_iam_policy_document" "assume_role_codebuild" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_execution_role" {
  name               = "MyCodeBuildRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codebuild.json
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_full_access" {
  role       = aws_iam_role.codebuild_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_power_user" {
  role       = aws_iam_role.codebuild_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "amazon_code_commit_full_access" {
  role       = aws_iam_role.codebuild_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_policy" "codebuild_base_policy" {
  name = "CodeBuildBasePolicy_test_codepipeline"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Resource : [
          aws_s3_bucket.pipeline.arn,
          "${aws_s3_bucket.pipeline.arn}/*"
        ],
        Action : [
          "s3:PutObject",
          "s3:Get*",
          "s3:List*"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        Resource : [
          "arn:aws:codebuild:ap-northeast-1:181804339651:report-group/test_codepipeline-*"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "ssm:GetParameters"
        ],
        Resource : [
          "arn:aws:ssm:ap-northeast-1:181804339651:parameter/dockerhub-token",
          "arn:aws:ssm:ap-northeast-1:181804339651:parameter/dockerhub-user"
        ]
      },
      {
        Effect : "Allow",
        Action : [
          "logs:*"
        ]
        Resource : [
          aws_cloudwatch_log_group.test_codepipeline.arn,
          "${aws_cloudwatch_log_group.test_codepipeline.arn}:*"

        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role = aws_iam_role.codebuild_execution_role.name

  policy_arn = aws_iam_policy.codebuild_base_policy.arn
}

#########################
# ECS IAM
#########################
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "MyEcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "amazon_ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloud_watch_agent_server_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#########################
# CodeDeploy IAM
#########################
data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "codedeploy" {
  name               = "codedeploy"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

## ECS CodedeployPolicy

resource "aws_iam_role_policy_attachment" "ecs_deploy" {
  role       = aws_iam_role.codedeploy.id
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

## Codedeploy IAM Role Policy
data "aws_iam_policy_document" "codedeploy_iam_role_policy" {
  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DeleteLifecycleHook",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:PutLifecycleHook",
      "autoscaling:RecordLifecycleActionHeartbeat",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "sns:*",
      "tag:GetTags",
      "tag:GetResources",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}