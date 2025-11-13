  resource "aws_ssm_parameter" "acm_certificate_arn" { # store backend alb_listener arn in ssm parameter store
  name  = "/${var.project}/${var.environment}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.spandanas.arn
}