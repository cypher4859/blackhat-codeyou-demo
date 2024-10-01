resource "aws_lb" "ecs_alb" {
    name               = "ecs-blackhat-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = var.security_groups #[aws_security_group.security_group.id]
    subnets            = var.subnets # [aws_subnet.subnet.id, aws_subnet.subnet2.id]

    tags = {
      Name = "ecs-alb"
    }
}

resource "aws_lb_listener" "ecs_alb_listener" {
    load_balancer_arn = aws_lb.ecs_alb.arn
    port              = 8080
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.ecs_tg.arn
    }
}

resource "aws_lb_target_group" "ecs_tg" {
    name        = "ecs-target-group"
    port        = 8080
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id

    # NOTE: Pretty sure the healthcheck was causing it to fail
    health_check {
      path = "/"
    }
}