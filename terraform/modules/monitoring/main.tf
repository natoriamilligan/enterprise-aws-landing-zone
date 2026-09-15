resource "aws_cloudwatch_metric_alarm" "banking_cpu" {
  alarm_name          = "banking-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors cpu utilization"
  datapoints_to_alarm = 5
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.banking_ecs_alerts.arn]
  ok_actions          = [aws_sns_topic.banking_ecs_alerts.arn]
  dimensions = {
    ClusterName  = var.banking_cluster_name
    ServiceName  = var.banking_service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "banking_memory" {
  alarm_name          = "banking-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors memory utilization"
  datapoints_to_alarm = 5
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.banking_ecs_alerts.arn]
  ok_actions          = [aws_sns_topic.banking_ecs_alerts.arn]
  dimensions = {
    ClusterName  = var.banking_cluster_name
    ServiceName  = var.banking_service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "payments_cpu" {
  alarm_name          = "payments-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors cpu utilization"
  datapoints_to_alarm = 5
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.payments_ecs_alerts.arn]
  ok_actions          = [aws_sns_topic.payments_ecs_alerts.arn]
  dimensions = {
    ClusterName  = var.payments_cluster_name
    ServiceName  = var.payments_service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "payments_memory" {
  alarm_name          = "payments-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors memory utilization"
  datapoints_to_alarm = 5
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.payments_ecs_alerts.arn]
  ok_actions          = [aws_sns_topic.payments_ecs_alerts.arn]
  dimensions = {
    ClusterName  = var.payments_cluster_name
    ServiceName  = var.payments_service_name
  }
}

resource "aws_sns_topic" "ecs_banking_updates" {
  name = "ecs-banking"
}

resource "aws_sns_topic_subscription" "banking_email" {
  topic_arn = aws_sns_topic.ecs_banking_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_sns_topic" "ecs_payments_updates" {
  name = "ecs-payments"
}

resource "aws_sns_topic_subscription" "payments_email" {
  topic_arn = aws_sns_topic.ecs_payments_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_cloudwatch_metric_alarm" "private_link_endpoint" {
  alarm_name          = "private-link-endpoint"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "PacketsDropped"
  namespace           = "AWS/PrivateLinkEndpoints"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This metric monitors the number of packets dropped"
  datapoints_to_alarm = 5
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.private_link.arn]
  ok_actions          = [aws_sns_topic.private_link.arn]
  dimensions = {
    VPCEndpointId  = var.endpoint_id
  }
}

resource "aws_cloudwatch_metric_alarm" "private_link_endpoint_service" {
  alarm_name          = "private-link-endpoint-service"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "RstPacketsSent"
  namespace           = "AWS/PrivateLinkServices"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This metric monitors unhealthy targets of the endpoint service"
  datapoints_to_alarm = 5
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.private_link.arn]
  ok_actions          = [aws_sns_topic.private_link.arn]
  dimensions = {
    ServiceId  = var.endpoint_service_id
  }
}

resource "aws_sns_topic" "private_link" {
  name = "private-link"
}

resource "aws_sns_topic_subscription" "private_link_email" {
  topic_arn = aws_sns_topic.private_link_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_sns_topic_subscription" "private_link_service_email" {
  topic_arn = aws_sns_topic.private_link_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_host" {
  alarm_name          = "alb-unhealthy-host"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This metric monitors ECS targets that fail health checks"
  datapoints_to_alarm = 2
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.alb.arn]
  ok_actions          = [aws_sns_topic.alb.arn]
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.alb_target_group_arn_suffix
  }
}

resource "aws_sns_topic" "alb" {
  name = "alb"
}

resource "aws_sns_topic_subscription" "alb_email" {
  topic_arn = aws_sns_topic.alb_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_cloudwatch_metric_alarm" "nlb_unhealthy_host" {
  alarm_name          = "nlb-unhealthy-host"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This metric monitors ECS targets that fail health checks"
  datapoints_to_alarm = 2
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.nlb.arn]
  ok_actions          = [aws_sns_topic.nlb.arn]
  dimensions = {
    LoadBalancer = var.nlb_arn_suffix
    TargetGroup  = var.nlb_target_group_arn_suffix
  }
}

resource "aws_sns_topic" "nlb" {
  name = "nlb"
}

resource "aws_sns_topic_subscription" "nlb_link_email" {
  topic_arn = aws_sns_topic.nlb_updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_cloudwatch_dashboard" "banking_payments_dashboard" {
  dashboard_name = "banking-payments-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "ClusterName", var.banking_cluster_name,
              "ServiceName", var.banking_service_name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Banking CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "MemoryUtilization",
              "ClusterName", var.banking_cluster_name,
              "ServiceName", var.banking_service_name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Banking Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "ClusterName", var.payments_cluster_name,
              "ServiceName", var.payments_service_name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Payments CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "MemoryUtilization",
              "ClusterName", var.payments_cluster_name,
              "ServiceName", var.payments_service_name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Payments Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/PrivateLinkEndpoints",
              "PacketsDropped",
              "VPCEndpointId", var.endpoint_id
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Private Link Endpoint Packets Dropped"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/PrivateLinkServices",
              "RstPacketsSent",
              "ServiceId", var.endpoint_service_id
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "Endpoint Service Resets"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "UnHealthyHostCount",
              "LoadBalancer", var.alb_arn_suffix,
              "TargetGroup", var.alb_target_group_arn_suffix
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "ALB Unhealthy Hosts"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/NetworkELB",
              "UnHealthyHostCount",
              "LoadBalancer", var.nlb_arn_suffix,
              "TargetGroup", var.nlb_target_group_arn_suffix
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "NLB Unhealthy Hosts"
        }
      }
    ]
  })
}
