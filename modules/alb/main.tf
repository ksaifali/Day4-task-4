# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  enable_deletion_protection = false # Set to true in production

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

# Target Group (for Strapi on port 1337)
resource "aws_lb_target_group" "this" {
  name        = "${var.name_prefix}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    path                = var.health_check_path # "/" or "/admin" – Strapi responds OK-ish
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200-399" # Strapi often redirects (302) or serves content
    protocol            = "HTTP"
  }

  tags = {
    Name = "${var.name_prefix}-tg"
  }
}

# HTTP Listener (port 80) → forward to target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Attach the single EC2 instance to the target group
resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance
  port             = var.target_port
}
