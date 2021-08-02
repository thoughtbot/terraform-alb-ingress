resource "aws_cloudwatch_metric_alarm" "response_time" {
  for_each = var.target_groups

  alarm_name          = "${local.alarm_prefixes[each.key]}-response-time"
  alarm_description   = "${each.value.name} is responding very slowly"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_minutes
  threshold           = var.slow_response_threshold
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "p95"
    return_data = true
    label       = "95th Percentile"

    metric {
      period      = "60"
      stat        = "p95"
      namespace   = "AWS/ApplicationELB"
      metric_name = "TargetResponseTime"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }

  alarm_actions = var.alarm_actions.*.arn
  ok_actions    = var.alarm_actions.*.arn
}

resource "aws_cloudwatch_metric_alarm" "error_responses" {
  for_each = var.target_groups

  alarm_name          = "${local.alarm_prefixes[each.key]}-error-responses"
  alarm_description   = "${each.value.name} is reporting a large number of errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_minutes
  threshold           = "5"
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "sum"
    return_data = true
    label       = "Error Count"
    expression  = "FILL(elb,0)+FILL(app,0)"
  }

  metric_query {
    id = "elb"
    metric {
      period      = "60"
      stat        = "Sum"
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_ELB_5XX_Count"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }

  metric_query {
    id = "app"
    metric {
      period      = "60"
      stat        = "Sum"
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_5XX_Count"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "failure_ratio" {
  for_each = var.target_groups

  alarm_name          = "${local.alarm_prefixes[each.key]}-success-failure-ratio"
  alarm_description   = "Failure responses for ${each.value.name} are abnormally high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_minutes
  threshold           = var.failure_threshold

  metric_query {
    id          = "average"
    return_data = true
    label       = "Failure Responses"
    expression  = "(FILL(r4xx,0)+FILL(r5xx,0))/(FILL(r2xx,1)+FILL(r3xx,0)+FILL(r4xx,0)+FILL(r5xx,0))*100"
  }

  metric_query {
    id = "r2xx"
    metric {
      period      = "60"
      stat        = "Sum"
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_2XX_Count"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }

  metric_query {
    id = "r3xx"
    metric {
      period      = "60"
      stat        = "Sum"
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_3XX_Count"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }

  metric_query {
    id = "r4xx"
    metric {
      period      = "60"
      stat        = "Sum"
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_4XX_Count"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }

  metric_query {
    id = "r5xx"
    metric {
      period      = "60"
      stat        = "Sum"
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_5XX_Count"

      dimensions = {
        LoadBalancer = var.alb.arn_suffix
        TargetGroup  = each.value.arn_suffix
      }
    }
  }

  alarm_actions = var.alarm_actions.*.arn
  ok_actions    = var.alarm_actions.*.arn
}

locals {
  alarm_prefixes = zipmap(
    keys(var.target_groups),
    [
      for target_group in values(var.target_groups) :
      join("-",
        distinct(split("-", join("-", [var.alb.name, target_group.name])))
      )
    ]
  )
}
