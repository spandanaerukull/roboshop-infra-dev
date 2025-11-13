locals { 
  ami_id = data.aws_ami.joindevops.id # AMI ID for the instances
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value # Security Group ID for MongoDB
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value # Security Group ID for Redis
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value # Security Group ID for MySQL
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value # Security Group ID for RabbitMQ
  database_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_id.value) # Subnet IDs for the database


common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform = "true"
  }

}

# Because those are Security Group IDs (sg_id) fetched once from SSM and stored in locals so you can reuse them across resources/modules without repeating data lookups — it improves readability, reduces duplication, and makes passing related IDs simpler. ("sq id" looks like a typo; should be "sg id".)

# locals is a way to define variables in Terraform that can be reused throughout your configuration.
# By using locals, you can avoid repeating the same expressions and make your code cleaner and more maintainable.
# It also helps to improve performance by reducing the number of times Terraform needs to evaluate the same expression.
# for detailed info go to the locals folder in vscode 