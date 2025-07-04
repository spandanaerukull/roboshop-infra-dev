resource "aws_instance" "mongodb" { # Create an mongodb instance for the database
  ami           = local.ami_id # Use the AMI ID from local variables
  instance_type = "t3.micro" # Specify the instance type
  vpc_security_group_ids = [local.mongodb_sg_id] # Use the Security Group ID from local variables
  subnet_id = local.database_subnet_id[0] # Use the first private subnet ID from local variables

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mongodb" # Name tag for the instance
    }
  )
}

resource "terraform_data" "mongodb" { #thia is null resource it will not creat any instance just used for connecting the instance 
    triggers_replace = [
        aws_instance.mongodb.id
    ]
  
  provisioner "file" {  #file is for copy
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
}
   connection {
       type = "ssh"
       user = "ec2-user"
       password = "DevOps321"
       host = aws_instance.mongodb.private_ip
     }

     provisioner "remote-exec" {
       inline = [ 
       "chmod +x /tmp/bootstrap.sh",
       "sudo sh /tmp/bootstrap.sh mongodb"
        ]
     }
}

 resource "aws_instance" "redis" { # Create an redis instance for the database
  ami           = local.ami_id # Use the AMI ID from local variables
  instance_type = "t3.micro" # Specify the instance type
  vpc_security_group_ids = [local.redis_sg_id] # Use the Security Group ID from local variables
  subnet_id = local.database_subnet_id[0] # Use the first private subnet ID from local variables

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-redis" # Name tag for the instance
    }
  )
}

resource "terraform_data" "redis" { #thia is null resource it will not creat any instance just used for connecting the instance 
    triggers_replace = [
        aws_instance.redis.id
    ]
  
  provisioner "file" {  #file is for copy
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
}
   connection {
       type = "ssh"
       user = "ec2-user"
       password = "DevOps321"
       host = aws_instance.redis.private_ip
     }

     provisioner "remote-exec" {
       inline = [ 
       "chmod +x /tmp/bootstrap.sh",
       "sudo sh /tmp/bootstrap.sh redis"
        ]
     }


}
#######
resource "aws_instance" "mysql" { # Create an redis instance for the database
  ami           = local.ami_id # Use the AMI ID from local variables
  instance_type = "t3.micro" # Specify the instance type
  vpc_security_group_ids = [local.mysql_sg_id] # Use the Security Group ID from local variables
  subnet_id = local.database_subnet_id[0] # Use the first private subnet ID from local variables

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mysql" # Name tag for the instance
    }
  )
}

resource "terraform_data" "mysql" { #thia is null resource it will not creat any instance just used for connecting the instance 
    triggers_replace = [
        aws_instance.mysql.id
    ]
  
  provisioner "file" {  #file is for copy
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
}
   connection {
       type = "ssh"
       user = "ec2-user"
       password = "DevOps321"
       host = aws_instance.mysql.private_ip
     }

     provisioner "remote-exec" {
       inline = [ 
       "chmod +x /tmp/bootstrap.sh",
       "sudo sh /tmp/bootstrap.sh mysql"
        ]
     }


}

resource "aws_instance" "rabbitmq" { # Create an redis instance for the database
  ami           = local.ami_id # Use the AMI ID from local variables
  instance_type = "t3.micro" # Specify the instance type
  vpc_security_group_ids = [local.rabbitmq_sg_id] # Use the Security Group ID from local variables
  subnet_id = local.database_subnet_id[0] # Use the first private subnet ID from local variables

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-rabbitmq" # Name tag for the instance
    }
  )
}

resource "terraform_data" "rabbitmq" { #thia is null resource it will not creat any instance just used for connecting the instance 
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]
  
  provisioner "file" {  #file is for copy
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
}
   connection {
       type = "ssh"
       user = "ec2-user"
       password = "DevOps321"
       host = aws_instance.rabbitmq.private_ip
     }

     provisioner "remote-exec" {
       inline = [ 
       "chmod +x /tmp/bootstrap.sh",
       "sudo sh /tmp/bootstrap.sh rabbitmq"
        ]
     }


}