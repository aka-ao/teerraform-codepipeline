resource "aws_ecs_cluster" "test_codepipeline" {
  name = "test_codepipeline"
}

resource "aws_ecs_task_definition" "task" {
  cpu    = "256"
  memory = "512"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : aws_cloudwatch_log_group.test_codepipeline.name,
          awslogs-region : "ap-northeast-1",
          awslogs-stream-prefix : "ecs"
        }
      },
      portMappings : [
        {
          hostPort : 8080,
          protocol : "tcp",
          containerPort : 8080
        }
      ],
      cpu : 256,
      memoryReservation : 512,
      essential : true,
      name : "test_codepipeline",
      image : "${aws_ecr_repository.test_codepipeline.repository_url}:latest",
    }
  ])
  family = "test_codepipeline"
}

output "task_definition" {
  value = aws_ecs_task_definition.task.arn
}