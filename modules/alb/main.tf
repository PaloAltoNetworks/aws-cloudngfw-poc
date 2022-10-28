
data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = ["591542846629"] # AWS

  filter {
      name   = "name"
      values = ["*amazon-ecs-optimized"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

data "aws_ami" "latest_linux" {
  most_recent = true
  owners = ["137112412989"] # AWS

  filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

data "aws_key_pair" "key_name" {
  filter {
    name = "key-name"
    values = [var.ssh-key-name]
  }
}

resource "aws_lb" "alb" {
  load_balancer_type = var.load-balancer.type
  name               = "${var.prefix-name-tag}${var.load-balancer.name}"
  internal           = false
  ip_address_type    = "ipv4"
  subnets            = [ for subnet in var.load-balancer.subnets: var.vpc.subnet_ids["${var.vpc.name}-${subnet}"] ]
  security_groups    = [var.lb-security-group]

  tags = merge({ Name = "${var.prefix-name-tag}${var.load-balancer.name}" }, var.global-tags)
}

resource "aws_lb_target_group" "alb" {
  name     = "${aws_lb.alb.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc.id

  health_check {
    path = "/index.php"
  }

  tags = merge({ Name = "${var.prefix-name-tag}${var.load-balancer.name}-tg" }, var.global-tags)
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  tags = var.global-tags
}

resource "aws_launch_configuration" "alb" {
  name            = "${var.prefix-name-tag}${var.load-balancer.name}-${var.instance-launch-config.name}"
  image_id        = data.aws_ami.latest_linux.id
  instance_type   = var.instance-launch-config.instance_type
  user_data       = file("${path.module}/../${var.instance-launch-config.setup-file}")
  security_groups = [var.ec2-security-group]
  key_name        = data.aws_key_pair.key_name.key_name
}

resource "aws_autoscaling_group" "alb" {
  name                  = "${aws_lb.alb.name}-asg"
  min_size              = var.autoscale-group.min_size
  max_size              = var.autoscale-group.max_size
  desired_capacity      = var.autoscale-group.desired_capacity
  launch_configuration  = aws_launch_configuration.alb.name
  vpc_zone_identifier   = [ for subnet in var.autoscale-group.subnets: var.vpc.subnet_ids["${var.vpc.name}-${subnet}"] ]
}

resource "aws_autoscaling_attachment" "alb" {
  autoscaling_group_name  = aws_autoscaling_group.alb.id
  lb_target_group_arn     = aws_lb_target_group.alb.arn
}

output "LOAD_BALANCER_DNS_ADDRESS" {
  value = aws_lb.alb.dns_name
}