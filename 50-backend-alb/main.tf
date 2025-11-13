module "backend_alb" {
  source = "terraform-aws-modules/alb/aws" # used open-source module from the Terraform Registry
  internal = true # this is internal ALB so i kept as true , it is private ALB
   version = "9.16.0" # Specify the version of the module to use

  name    = "${var.project}-${var.environment}-backend-alb" # roboshop1-dev-backend-alb
  vpc_id  = local.vpc_id # Fetch the VPC ID from SSM Parameter Store
  subnets = local.private_subnet_ids
  create_security_group = false
  security_groups = [local.backend_alb_sg_ids]
  enable_deletion_protection = false
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-backend-alb"
    }
  )
}


# creating the listener#
resource "aws_lb_listener" "backend_alb" { 
  load_balancer_arn = module.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>hello, i am from backend ALB</h1>"
      status_code  = "200"
    }
  }
}

#creating r53 record for bacleand alb
resource "aws_route53_record" "backend_alb" {
  zone_id = var.zone_id
  name    = "*.backend-dev.${var.zone_name}" #  exp:somthing.backend-dev.spandanas.click
  type    = "A"

  alias {                     #An alias in Route53 is like a shortcut that maps your custom domain name 
    name                   = module.backend_alb.dns_name
    zone_id                = module.backend_alb.zone_id #this is the zone id of alb 
    evaluate_target_health = true
  }
}