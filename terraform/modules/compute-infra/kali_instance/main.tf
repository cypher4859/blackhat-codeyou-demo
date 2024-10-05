data "aws_vpc" "main" {
    id = var.vpc_id
}

resource "aws_security_group" "kali" {
    name   = "blackhat-kali-security-group"
    vpc_id = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.kali.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_rdp" {
  security_group_id = aws_security_group.kali.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3390
  ip_protocol       = "tcp"
  to_port           = 3390
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.kali.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "kali" {
  ami           = "ami-0327cf1c5e479e093"
  instance_type = "t3.medium"
  key_name = var.key_name
  subnet_id = var.public_subnet_id
  security_groups = [ aws_security_group.kali.id ]

  tags = {
      Name = "Kali"
  }

  root_block_device {
    volume_size = 40 # in GB <<----- I increased this!
    volume_type = "standard"
    encrypted   = false
    # kms_key_id  = data.aws_kms_key.customer_master_key.arn
  }
}
