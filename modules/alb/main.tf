resource "aws_alb" "this" {
  name            = join("-", concat(var.namespace, [var.name]))
  security_groups = [aws_security_group.this.id]

  dynamic "connection_logs" {
    for_each = var.enable_connection_logs ? [1] : []
    content {
      bucket  = var.s3_logs_bucket_name != "" ? var.s3_logs_bucket_name : aws_s3_bucket.lb_logs[0].id
      prefix  = "connectionlogs"
      enabled = true
    }
  }

  dynamic "access_logs" {
    for_each = var.enable_access_logs ? [1] : []
    content {
      bucket  = var.s3_logs_bucket_name != "" ? var.s3_logs_bucket_name : aws_s3_bucket.lb_logs[0].id
      prefix  = "accesslogs"
      enabled = true
    }
  }
  subnets = var.subnet_ids
  tags    = var.tags
}

resource "aws_s3_bucket" "lb_logs" {
  count  = var.s3_logs_bucket_name == "" ? 1 : 0
  bucket = var.s3_logs_bucket_name == "" ? "${var.name}-alb-logs-${random_id.suffix.hex}" : var.s3_logs_bucket_name
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_security_group" "this" {
  description = var.description
  name        = join("-", concat(var.namespace, [var.name]))
  tags        = var.tags
  vpc_id      = var.vpc_id
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
