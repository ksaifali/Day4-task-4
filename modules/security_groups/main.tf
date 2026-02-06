# Security Group for the Application Load Balancer (public)
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for public ALB - allow HTTP inbound"
  vpc_id      = var.vpc_id

  # Allow HTTP from anywhere (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from internet"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

# Security Group for the private EC2 instance
resource "aws_security_group" "ec2" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Security group for private Strapi EC2 - allow from ALB + SSH from my IP"
  vpc_id      = var.vpc_id

  # Allow traffic from ALB only (port 1337 - Strapi default)
  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Allow Strapi traffic from ALB"
  }

  # Allow SSH from your IP only (for debugging)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH access from my IP"
  }

  # Allow all outbound traffic (for Docker pulls, apt updates, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-ec2-sg"
  }
}
