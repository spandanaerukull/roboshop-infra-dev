data "aws_ssm_parameter" "vpc_id" {  # Fetch the VPC ID from SSM Parameter Store
  name = "/${var.project}/${var.environment}/vpc_id"
}










#note
#datasource is used for fetching the information from the AWS SSM Parameter Store
#parameter is used to store the information in the AWS SSM Parameter Store
#module is used to create the security group using the terraform-aws-securitygroup module