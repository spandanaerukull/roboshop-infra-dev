  resource "aws_ssm_parameter" "frontend_alb_listener_arn" { # store backend alb_listener arn in ssm parameter store
  name  = "/${var.project}/${var.environment}/frontend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.frontend_alb.arn
}