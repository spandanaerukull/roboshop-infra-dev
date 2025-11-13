  resource "aws_ssm_parameter" "backend_alb_listener_arn" { # store backend alb_listener arn in ssm parameter store
  name  = "/${var.project}/${var.environment}/backend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.backend_alb.arn
}