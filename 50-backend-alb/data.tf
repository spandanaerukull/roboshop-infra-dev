data "aws_ssm_parameter" "vpc_id" {  # Fetch the VPC ID from SSM Parameter Store
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}
data "aws_ssm_parameter" "backend_alb_sg_id" {  # Fetch the Security Group ID from SSM Parameter Store
  name = "/${var.project}/${var.environment}/backend_alb_sg_id"
}







#note
#datasource is used for fetching the information from the AWS SSM Parameter Store
#parameter is used to store the information in the AWS SSM Parameter Store
#module is used to create the security group using the terraform-aws-securitygroup module