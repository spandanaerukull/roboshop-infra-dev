#vpn instance key
resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("c:\\devops\\spandu\\openvpn.pub") # location of the key
}

resource "aws_instance" "vpn" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_ids
  key_name               = aws_key_pair.openvpn.key_name # make sure this key is exits in aws 
  user_data              = file("openvpn.sh")  
                             # user data for vpn server condiguration,user data means configurations for the openvpi, that data i gave in openvpn.sh file 
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-vpn" #tag name roboshop1-dev-vpn
    }
  )
}

# here i need to creat r53 for the vpn for due to vpn issue i did'nt created 






# here vpn we use to connect the database instances and configure the ansible playbooks