data "aws_ssm_parameter" "vpc_id" {  # Fetch the VPC ID from SSM Parameter Store
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue_sg_id"
}

data "aws_ssm_parameter" "backend_alb_listener_arn" {
  name = "/${var.project}/${var.environment}/backend_alb_listener_arn"
}



data "aws_ami" "joindevops" { # Fetch the AMI ID for a specific Amazon Machine Image (AMI)
  owners = ["973714476881"]
  most_recent = true

    filter {
        name   = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

        filter {
        name   = "root-device-type"
        values = ["ebs"]
       }

       filter {
        name   = "virtualization-type"
        values = ["hvm"] # hvm or paravirtual
    }

}




#note
#datasource is used for fetching the information from the AWS SSM Parameter Store
#parameter is used to store the information in the AWS SSM Parameter Store
#module is used to create the security group using the terraform-aws-securitygroup module