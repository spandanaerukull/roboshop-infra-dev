

module "frontend_alb" {
  source = "terraform-aws-modules/alb/aws" # used open-source module from the Terraform Registry
  internal = false # this is internal ALB so i kept as true , it is private ALB
   version = "9.16.0" # Specify the version of the module to use

  name    = "${var.project}-${var.environment}-frontend-alb" # roboshop1-dev-backend-alb
  vpc_id  = local.vpc_id # Fetch the VPC ID from SSM Parameter Store
  subnets = local.public_subnet_ids
  create_security_group = false
  security_groups = [local.frontend_alb_sg_ids]
  enable_deletion_protection = false
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-frontend-alb"
    }
  )
}


# creating the listener#
resource "aws_lb_listener" "frontend_alb" { 
  load_balancer_arn = module.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"   
  ssl_policy = "ELBSecurity-2016-08" # this is ssl policy for alb listener used for https security policy
  certificate_arn = local.acm_certificate_arn # fetching from ssm parameter store

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>hello, i am from frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

#creating r53 record for frontend alb
resource "aws_route53_record" "frontend_alb" {
  zone_id = var.zone_id
  name    = "*.${var.zone_name}" #  exp: .spandanas.click
  type    = "A"

  alias {                     #An alias in Route53 is like a shortcut that maps your custom domain name 
    name                   = module.frontend_alb.dns_name
    zone_id                = module.frontend_alb.zone_id #this is the zone id of alb 
    evaluate_target_health = true
  }
}