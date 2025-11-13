variable "project" {
    default = "roboshop1"
}

variable "environment" {
    default = "dev"
  
}

variable "frontend_sg_name" {
    type = string
    default = "frontend"
  
}

variable "frontend_sg_description" {
    type = string
    default = "created sg for frontend instance"
}

variable "bastion_sg_name" {
    type = string
    default = "bastion"
  
}

variable "bastion_sg_description" {
    type = string
    default = "created sg for bastion instance"
}


variable "mongodb_ports_vpn" {
  default = [22,27017] # 22 for SSH, 27017 for MongoDB, port 27017 is the default MongoDB port uses to listen for incoming connections (traffic)
}

variable "redis_ports_vpn" {
  default = [22,6379] # 22 for SSH, 6379 for Redis, port 6379 is the default Redis port uses to listen for incoming connections (traffic)
}

variable "mysql_ports_vpn" {
  default = [22,3306] # 22 for SSH, 3306 for MySQL, port 3306 is the default MySQL port uses to listen for incoming connections (traffic)
}

variable "rabbitmq_ports_vpn" {
  default = [22,5672] # 22 for SSH, 5672 for RabbitMQ, port 5672 is the default RabbitMQ port uses to listen for incoming connections (traffic)
}


