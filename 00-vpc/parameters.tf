# Store the VPC ID in SSM Parameter Store
# Ensure the VPC module is created before this

#this parameteis to get the vpc id 
resource "aws_ssm_parameter" "vpc_id" {  # Store the VPC ID in SSM Parameter Store
  depends_on = [module.vpc] # Ensure the VPC module is created before this
  name  = "/${var.project}/${var.environment}/vpc_id" # Parameter name in SSM
  type  = "String" # Parameter type
  value = module.vpc.vpc_id # Value to store, which is the VPC ID from the VPC module
}

#thai paramete is to get the public subnet ids
resource "aws_ssm_parameter" "public_subnet_ids" {  # Store the VPC ID in SSM Parameter Store
  name  = "/${var.project}/${var.environment}/public_subnet_ids" # Parameter name in SSM
  type  = "StringList" # Parameter type
  value = join(",", module.vpc.public_subnet_ids) # Value to store, which is the VPC ID from the VPC module #by using join we are converting list to string
}

 #thai paramete is to get the private subnet ids
resource "aws_ssm_parameter" "private_subnet_ids" {  # Store the VPC ID in SSM Parameter Store
  name  = "/${var.project}/${var.environment}/private_subnet_ids" # Parameter name in SSM
  type  = "StringList" # Parameter type
  value = join(",", module.vpc.private_subnet_ids) # Value to store, which is the VPC ID from the VPC module #by using join we are converting list to string
}

#thai para mete is to get the database subnet ids
resource "aws_ssm_parameter" "database_subnet_ids" {  # Store the VPC ID in SSM Parameter Store
  name  = "/${var.project}/${var.environment}/database_subnet_ids" # Parameter name in SSM
  type  = "StringList" # Parameter type
  value = join(",", module.vpc.database_subnet_ids) # Value to store, which is the VPC ID from the VPC module #by using join we are converting list to string
}