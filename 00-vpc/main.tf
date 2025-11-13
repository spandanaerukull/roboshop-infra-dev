module "vpc" {
    #source = "../terraform-aws-vpc-module" # this is my local source(which is in my laptop)
    source = "git::https://github.com/spandanaerukull/terraform-aws-vpc-module.git?ref=main" # this is the source from spandana github repository, infuture also we can copy the module link and use other people modules also we can use like this because we cannot keep everthing in local right so just take link and keep at a source and use it 
    # this values are harded coded directly
    # /* project = "roboshop1"
    #  environment = "dev"
    # public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]

    #this values are passed from variable.tf file
    project = var.project
    environment = var.environment   
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_subnet_cidr = var.database_subnet_cidr

    is_peering_required = true # this is hardcoded to true, so that peering connection will be created
}

# by writing this outputs code  here we get the value in the gitbash terminal & this is wrot for testing purpose only, i want this vales in aws ssm paramets store, for that i created parameters.tf file that file is used to store the values in ssm parameter store
#    output "vpc_id" {  # Store the VPC ID in SSM Parameter Store
#      value = module.vpc.public_subnet_ids 
  
#  }

#  output "vpc_id_main" {  # this used to get the private subnet ids from the module ,we should mention the different outputs names so that only we get the values
#    value = module.vpc.private_subnet_ids
#  }