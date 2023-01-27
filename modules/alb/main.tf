resource "aws_alb" "this" {
  name            = join("-", concat(var.namespace, [var.name]))
  security_groups = [aws_security_group.this.id]
  subnets         = var.subnet_ids
  tags            = var.tags
}

resource "aws_security_group" "this" {
  description = var.description
  name        = join("-", concat(var.namespace, [var.name]))
  tags        = var.tags
  vpc_id      = var.vpc_id

  lifecycle {
    # You can't remove the last security group
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "aws_alb_http_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP ingress"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "aws_alb_https_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTPS ingress"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "aws_alb_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all egress"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = 0
  type              = "egress"
}
