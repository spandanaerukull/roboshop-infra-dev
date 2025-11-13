resource "aws_instance" "bastion" { # Create an EC2 instance for the Bastion host
  ami           = local.ami_id # Use the AMI ID from local variables
  instance_type = "t3.micro" # Specify the instance type
  vpc_security_group_ids = [local.bastion_sg_id] # Use the Security Group ID from local variables
  subnet_id = local.public_subnet_ids # Use the first public subnet ID from local variables

# this is for creating more memory
 root_block_device {
   volume_size = 50 # Size of the root volume in GB
   volume_type = "gp3" 
 }

# Tag the Bastion host instance
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-bastion" # Name tag for the instance
    }
  )
}