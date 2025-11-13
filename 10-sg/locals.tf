locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value   # Fetch the VPC ID from SSM Parameter Store
}