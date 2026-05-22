resource "aws_instance" "web" {
  ami                         = "ami-003bce5ba6a96a706"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.web.id]

  tags = merge(local.common_tags, {
    Name = local.resource_names.web_instance
  })
}

resource "aws_security_group" "web" {
  description = "Security group allowing traffic on ports 443 and 80"
  name        = local.resource_names.web_security
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = local.resource_names.web_security
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
