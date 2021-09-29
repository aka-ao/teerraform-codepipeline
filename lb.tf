resource "aws_alb" "test_codepipeline_alb" {
  name = "test-codepipeline-alb"
  subnets = [
    aws_subnet.public-subnet-1a.id,
    aws_subnet.public-subnet-1c.id
  ]
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "blue" {
  name        = "blue"
  protocol    = "HTTP"
  port        = "8080"
  vpc_id      = aws_vpc.test_codepipeline.id
  target_type = "ip"
  health_check {
    protocol = "HTTP"
    path     = "/hello"
    matcher  = 200
  }
}

resource "aws_lb_target_group" "green" {
  name        = "green"
  protocol    = "HTTP"
  port        = "8080"
  vpc_id      = aws_vpc.test_codepipeline.id
  target_type = "ip"
  health_check {
    protocol = "HTTP"
    path     = "/hello"
    matcher  = 200
  }
}

resource "aws_lb_listener" "test_codepipeline_alb_listener" {
  load_balancer_arn = aws_alb.test_codepipeline_alb.arn
  port              = 8080
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}

output "public_subnet1" {
  value = aws_subnet.public-subnet-1a.id
}

output "public_subnet2" {
  value = aws_subnet.public-subnet-1c.id
}

output "service_sg" {
  value = aws_security_group.ecs_service.id
}

output "blue_tg_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_tg_arn" {
  value = aws_lb_target_group.green.arn
}

output "alb_dns" {
  value = "http://${aws_alb.test_codepipeline_alb.dns_name}:8080/hello"
}