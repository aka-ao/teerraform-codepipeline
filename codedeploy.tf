//resource "aws_codedeploy_app" "app" {
//  compute_platform = "ECS"
//  name             = "test-ecs"
//}
//
//resource "aws_codedeploy_deployment_group" "group" {
//  app_name               = aws_codedeploy_app.app.name
//  deployment_group_name  = "test-bg-deploy-dg"
//  service_role_arn       = aws_iam_role.codedeploy.arn
//  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
//
//  auto_rollback_configuration {
//    enabled = true
//    events  = ["DEPLOYMENT_FAILURE"]
//  }
//
//  blue_green_deployment_config {
//    deployment_ready_option {
//      action_on_timeout = "CONTINUE_DEPLOYMENT"
//    }
//
//    terminate_blue_instances_on_deployment_success {
//      action                           = "TERMINATE"
//      termination_wait_time_in_minutes = "10" # デプロイ成功後の環境保持時間
//    }
//  }
//
//  deployment_style {
//    deployment_option = "WITH_TRAFFIC_CONTROL"
//    deployment_type   = "BLUE_GREEN"
//  }
//
//  ecs_service {
//    cluster_name = aws_ecs_cluster.test_codepipeline.name
//    service_name = "test_codepipeline"
//  }
//
//  load_balancer_info {
//    target_group_pair_info {
//      prod_traffic_route {
//        listener_arns = [aws_lb_listener.test_codepipeline_alb_listener.arn]
//      }
//
//      target_group {
//        name = aws_lb_target_group.blue.name
//      }
//
//      target_group {
//        name = aws_lb_target_group.green.name
//      }
//    }
//  }
//}