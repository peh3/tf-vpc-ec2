module "vpc" {
 source  = "terraform-aws-modules/vpc/aws"


 name = "tk-tf-module-vpc" # Change this!!!
 cidr = "10.0.0.0/16"


 #azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
 #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
 #public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
 #database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
azs             = slice(data.aws_availability_zones.available.names, 0, 1)
public_subnets  = ["10.0.101.0/24"]

 enable_nat_gateway   = false
 #single_nat_gateway   = true
 enable_dns_hostnames = true
 enable_ipv6 = false # Ensures no IPv6 CIDR block is requested from AWS

 #create_database_subnet_group = true
 #create_database_subnet_route_table     = true
 #create_database_internet_gateway_route = false

 tags = {
  Terraform = "true"
  Environment = "tk-test"
 }
}
