module "frontend" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
    source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git" # Source from GitHub repository
   project = var.project

    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = "var.frontend_sg_description"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store



}


#from here its related to the bastion host #
module "bastion" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
    source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
   project = var.project

    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = "var.bastion_sg_description"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store



}


 # this security group is releated to backend application load blancer
    module "backend_alb" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
    source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
   project = var.project

    environment = var.environment
    sg_name = "backend-alb"
    sg_description = "for backend alb"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store
}

   # this security group is belongs to database momgodb
      module "mongodb" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
     source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
     project = var.project

    environment = var.environment
    sg_name = "mongodb"
    sg_description = "for mongodb"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store
  
}
    # this security group is belongs to database redis
      module "redis" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
     source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
     project = var.project

    environment = var.environment
    sg_name = "redis"
    sg_description = "for redis"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store

      }
    # this security group is belongs to database mysql
      module "mysql" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
     source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
     project = var.project

    environment = var.environment
    sg_name = "mysql"
    sg_description = "for mysql"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store

   }

  #  this security group is belongs to database rabbitmq
      module "rabbitmq" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
     source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
     project = var.project

    environment = var.environment
    sg_name = "rabbitmq"
    sg_description = "for rabbitmq"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store
      }

    module "vpn" {
#    source = "../../terraform-aws-securitygroup" # Path to the security group module
    source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
   project = var.project

    environment = var.environment
    sg_name = "vpn"
    sg_description = "for vpn"
    vpc_id = local.vpc_id # Fetch the VPC ID from SSM Parameter Store

}

 #bastion accepting connections from my laptop
#this rule is for allowing the traffic from my laptop to bastion host
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22 # Allow SSH connections
  to_port           = 22 # Allow SSH connections
  protocol          = "tcp" # Allow all TCP traffic
  cidr_blocks       = ["0.0.0.0/0"]  # this is used to allow the traffic from anywhere or any ip
  security_group_id = module.bastion.sg_id # Use the Security Group ID from the bastion module
  #this rule we should mention in the bastion security group
}

#backend ALB accepting connections from my bastion host on port no 80
#this rule is for allowing the traffic from bastion to backend alb
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80 # Allow  the connections
  to_port           = 80 # Allow the connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.bastion.sg_id # traffic comes from bastion host
  security_group_id = module.backend_alb.sg_id # traffic goes to backend alb
  #this rule we should mention in the backend alb security group
  
}

# vpn ports 22,443, 1194, 943  these are vpn ports
#this rule is for allowing the traffic from my laptop to vpn   

resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22 # Allow SSH connections
  to_port           = 22 # Allow SSH connections
  protocol          = "tcp" # Allow all TCP traffic
  cidr_blocks       = ["0.0.0.0/0"]  # this is used to allow the traffic from anywhere or any ip
  security_group_id = module.vpn.sg_id # Use the Security Group ID from the vpn module
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443 # Allow https connections
  to_port           = 443 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  cidr_blocks       = ["0.0.0.0/0"]  #  allow access from anywhere or any ip
  security_group_id = module.vpn.sg_id # Use the Security Group ID from the vpn module
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194 # Allow https connections
  to_port           = 1194 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  cidr_blocks       = ["0.0.0.0/0"]  #  allow access from anywhere or any ip
  security_group_id = module.vpn.sg_id # Use the Security Group ID from the vpn module
}


resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943 # Allow https connections
  to_port           = 943 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  cidr_blocks       = ["0.0.0.0/0"]  #  allow access from anywhere or any ip
  security_group_id = module.vpn.sg_id # Use the Security Group ID from the vpn module
}

##backend ALB accepting connections from vpn on port no 80
#this rule is for allowing the traffic from vpn to backend alb
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80 # Allow  the connections
  to_port           = 80 # Allow the connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id # traffic comes from vpn
  security_group_id = module.backend_alb.sg_id # traffic goes to backend alb
  #this rule we should mention in the backend alb security group
  
}

#### mongodb security groups#####
#this rule is for allowing the traffic from vpn to mongodb
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_ports_vpn)
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index] # here we are referring port numbers from variable,because we have 2 port numbers 
  to_port           = var.mongodb_ports_vpn[count.index] 
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id # traffic comes from vpn
  security_group_id = module.mongodb.sg_id # traffic goes to mongodb
}

#this rule is for allowing the traffic from vpn to redis
resource "aws_security_group_rule" "redis_ports_ssh" {
  count = length(var.redis_ports_vpn)
  type              = "ingress"
  from_port         = var.redis_ports_vpn[count.index] # here we are referring port numbers from variable,because we have 2 port numbers 
  to_port           = var.redis_ports_vpn[count.index] 
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id # traffic comes from vpn
  security_group_id = module.redis.sg_id 
}

#this rule is for allowing the traffic from vpn to mysql
resource "aws_security_group_rule" "mysql_ports_ssh" {
  count = length(var.mysql_ports_vpn)
  type              = "ingress"
  from_port         = var.mysql_ports_vpn[count.index] # here we are referring port numbers from variable,because we have 2 port numbers 
  to_port           = var.mysql_ports_vpn[count.index] 
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id # traffic comes from vpn
  security_group_id = module.mysql.sg_id 
}

#this rule is for allowing the traffic from vpn to rabbitmq
resource "aws_security_group_rule" "rabbitmq_ports_ssh" {
  count = length(var.rabbitmq_ports_vpn)
  type              = "ingress"
  from_port         = var.rabbitmq_ports_vpn[count.index] # here we are referring port numbers from variable,because we have 2 port numbers 
  to_port           = var.rabbitmq_ports_vpn[count.index] 
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id # traffic comes from vpn
  security_group_id = module.rabbitmq.sg_id 
}