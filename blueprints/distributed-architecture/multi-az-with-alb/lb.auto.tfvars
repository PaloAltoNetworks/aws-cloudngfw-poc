
instance-launch-config = {
  name           = "launch-config"
  instance_type  = "t2.micro"
  subnet         = "subnet"
  setup-file     = "ec2-startup-scripts/web-app-svr.sh"
  security_group = "ec2-sg"
}

load-balancer = {
  name    = "alb"
  type    = "application"
  subnets = ["lb-subnet-a", "lb-subnet-b"]
  security_group = "lb-sg"
}

autoscale-group = {
  min_size         = 2
  max_size         = 4
  desired_capacity = 2
  subnets          = ["subnet-a", "subnet-b"]
}