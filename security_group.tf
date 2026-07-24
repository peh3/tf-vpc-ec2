module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name_prefix}-sg"
  #description = "Example security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    ssh = {
      from_port   = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "SSH from anywhere"
    }
    https = {
      from_port   = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS from all traffic"
      #cidr_ipv4   = "10.0.0.0/16"
      #description = "HTTPS from internal"
    }
    #self-all = {
    #  ip_protocol                  = "-1"
    #  referenced_security_group_id = "self"
    #  description                  = "All traffic from members of this SG"
    #}
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "All traffic"
    }
  }

  # Standard IPv4 Egress
  #egress_rules        = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = "tk-test"
  }
}