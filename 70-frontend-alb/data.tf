data "aws_ssm_parameter" "vpc_id" {  # Fetch the VPC ID from SSM Parameter Store
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {  # Fetch the Security Group ID from SSM Parameter Store
  name = "/${var.project}/${var.environment}/frontend_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}


data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project}/${var.environment}/acm_certificate_arn"
}




#note
#datasource is used for fetching the information from the AWS SSM Parameter Store
#parameter is used to store the information in the AWS SSM Parameter Store
#module is used to create the security group using the terraform-aws-securitygroup module