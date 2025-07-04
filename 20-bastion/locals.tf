locals { # Define local variables for the Bastion host configuration
  ami_id = data.aws_ami.joindevops.id # Fetch the AMI ID from the data source
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value # Fetch the Security Group ID from SSM Parameter Store
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]  # Split the comma-separated string into a list and take the first subnet ID


common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform = "true"
  }








}


