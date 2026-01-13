aws_region     = "us-east-1"
env            = "dev"
vpc_cidr       = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
enable_monitoring = false   # prod

instance_type = "t3.medium"
key_name      = "ping"
