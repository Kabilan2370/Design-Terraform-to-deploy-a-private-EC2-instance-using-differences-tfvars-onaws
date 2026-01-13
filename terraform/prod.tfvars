aws_region     = "us-east-1"
env            = "prod"
vpc_cidr       = "10.1.0.0/16"
public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets = ["10.1.11.0/24", "10.1.12.0/24"]
enable_monitoring = true   # prod

instance_type = "t3.medium"
key_name      = "ping"
