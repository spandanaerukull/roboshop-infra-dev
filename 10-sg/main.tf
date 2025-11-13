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

     #this security group is belongs to catalogue
      module "catalogue" {
     source = "git::https://github.com/spandanaerukull/terraform-aws-securitygroup.git?ref=main" # Source from GitHub repository
     project = var.project

    environment = var.environment
    sg_name = "catalogue"
    sg_description = "for catalogue"
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


#froented-alb
module "frontend_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment

    sg_name = "frontend-alb"
    sg_description = "for frontend alb"
    vpc_id = local.vpc_id
}

# security group for frontend-alb
# resource "aws_security_group_rule" "frontend_frontend_alb" {
#   type              = "ingress"
#   from_port         = 80 # Allow SSH connections
#   to_port           = 80 # Allow SSH connections
#   protocol          = "tcp" # Allow all TCP traffic
#   cidr_blocks       = ["0.0.0.0/0"]  # this is used to allow the traffic from anywhere or any ip
#   security_group_id = module.frontend_alb.sg_id
#   source_security_group_id = module.frontend.sg_id
# }

resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443 # Allow SSH connections
  to_port           = 443 # Allow SSH connections
  protocol          = "tcp" # Allow all TCP traffic
  cidr_blocks       = ["0.0.0.0/0"]  # this is used to allow the traffic from anywhere or any ip
  security_group_id = module.frontend_alb.sg_id
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
  protocol          = "udp" # Allow all TCP traffic
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
# all this port connections belongs to backend alb to backend and database
#all this security groups belongs to catalogue group
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080 # Allow https connections
  to_port           = 8080 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.backend_alb.sg_id  # 
  security_group_id = module.catalogue.sg_id # Use the Security Gr

}
# this allows ssh access(port22) from your vpn server
#this is helpful if you're using ssh from within the vpn tunnel to connect to catalogue EC2 instance
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22 # Allow https connections
  to_port           = 22 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id    
  security_group_id = module.catalogue.sg_id # Use the Security Gr

}

#this allows web traffic (HTTP) on port 8080 (common for internal application or services) from the vpn to the catalogue service
resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080 # Allow https connections
  to_port           = 8080 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.vpn.sg_id #source comming fron vpn 
  security_group_id = module.catalogue.sg_id # Use the Security Gr

}
#
resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  from_port         = 22 # Allow https connections
  to_port           = 22 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.bastion.sg_id   #source comming from bastion 
  security_group_id = module.catalogue.sg_id # Use the Security Gr
}


resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017 # Allow https connections
  to_port           = 27017 # Allow https connections
  protocol          = "tcp" # Allow all TCP traffic
  source_security_group_id = module.catalogue.sg_id   #source comming from catalogue 
  security_group_id = module.mongodb.sg_id # Use the Security Gr
}

# user
resource "aws_security_group_rule" "user_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.user.sg_id
}

#Cart
resource "aws_security_group_rule" "cart_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.cart.sg_id
}

#Shipping
resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.shipping.sg_id
}

#Payment
resource "aws_security_group_rule" "payment_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.payment.sg_id
}

#Backend ALB
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.backend_alb.sg_id
}

#Frontend
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}

#Frontend ALB for http and https traffic 
# why http traffic is allowed from anywhere because frontend alb is public alb so it should accept traffic from anywhere
# so here we are allowing http traffic on port 80 from anywhere 
#There are a few common reasons why someone might configure the frontend ALB on port 80:
# Testing or Internal Setup:

# During development or internal environments (dev/stage), teams often use port 80 because it’s simpler — no need to configure SSL certificates.

# HTTP → HTTPS Redirection:

# Often, ALBs are configured with both ports (80 and 443).

# Port 80 is used only to redirect all HTTP requests to HTTPS (443).

# Example: If someone types http://myapp.com, the ALB automatically redirects it to https://myapp.com.

# SSL/TLS Termination not yet set up:

# Sometimes the certificate (ACM) isn’t ready yet, so they temporarily expose ALB on 80 until HTTPS configuration is completed.
resource "aws_security_group_rule" "frontend_alb_http" { # allowing http traffic on port 80 from anywhere 
  type              = "ingress"
  from_port         = 80 # allowing http traffic on port 80 from anywhere
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

#VPN ports 22, 443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

/* # backend ALB accepting connections from my bastion host on port no 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
} */
