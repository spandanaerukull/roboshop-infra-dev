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
  user_data              = file("openvpn.sh")            # user data for vpn server condiguration,user data means configurations for the openvpi, that data i gave in openvpn.sh file 
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-vpn" #tag name roboshop1-dev-vpn
    }
  )
}

# Creating route 53 Record for vpn
resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name    = "vpn-${var.environment}.${var.zone_name}" #vpn-dev.devops84.shop
  type    = "A"
  ttl     = 1
  records = [aws_instance.vpn.public_ip]
  allow_overwrite = true
}