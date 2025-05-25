# cloudwatch/alarm.tf
resource "aws_cloudwatch_metric_alarm" "iam_policy_delete_alarm" {
  alarm_name          = "IAMPolicyDeleteAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "IAMPolicyDeleteEventCount"
  namespace           = "CloudTrailMetrics"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggered when IAM policies are deleted"
  alarm_actions       = [aws_sns_topic.cloudtrail_alerts.arn]
}
