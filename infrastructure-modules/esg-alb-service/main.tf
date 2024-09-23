#create an autoscaling group

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.1"
}

# create the AutoScaling Group
resource "aws_autoscaling_group" "webserver" {

  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

# create the launch template
resource "aws_launch_template" "webserver" {
  name_prefix            = var.name
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.asg.id]

  user_data = base64decode(templatefile("${path.module}/user_data.sh", { server_port = var.server_port }))
}

# create the security group
resource "aws_security_group" "asg" {
  name = "${var.name}-asg"

}

# create the security group rule
resource "aws_security_group_rule" "asg_allow_http_inbound" {
  type                     = "ingress"
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.asg.id
  source_security_group_id = aws_security_group.alb.id
}

#----------------------------------------------------------
# Create an ALB to route traffic to the ASG
#----------------------------------------------------------

locals {
  subnet_per_az = { for subnet in data.aws_subnet.default : subnet.availability_zone => subnet.id... }

  subnet_for_alb = [for az, subnet in local.subnet_per_az : subnet[0]]
}

resource "aws_lb" "webserver_alb" {
  name               = var.name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.subnet_for_alb
}

resource "aws_lb_target_group" "webserver_target_group" {
  name     = var.name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "webserver_listener_rule" {
  listener_arn = aws_lb_listener.webserver_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_target_group.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

}

# create the security group
resource "aws_security_group" "alb" {
  name = "${var.name}-alb"
}

resource "aws_security_group_rule" "alb_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}



