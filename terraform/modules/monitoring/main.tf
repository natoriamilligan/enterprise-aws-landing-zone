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
}
