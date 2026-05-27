resource "aws_instance" "web" {
  ami           = "ami-003bce5ba6a96a706"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  user_data_replace_on_change = true

  user_data = <<-EOF
              #!/bin/bash

              cat > /opt/bitnami/nginx/html/index.html <<HTML
              <!DOCTYPE html>
              <html>
              <head>
                <title>My EC2 Website</title>
              </head>
              <body>
                <h1>Hello from Terraform!</h1>
                <p>This page replaced the default nginx page.</p>
              </body>
              </html>
              HTML

              systemctl restart nginx
              EOF
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

# This block only finds an existing Route 53 hosted zone.
# It does not create a new hosted zone or register a new domain.
# The hosted zone must already exist in this AWS account. 
data "aws_route53_zone" "main" {
  name         = "kevinduongdev.click"
  private_zone = false
}

#create DNS record
resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "test"
  type    = "A"
  ttl     = 300
  records = [aws_eip.web.public_ip]
}



resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"
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
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
