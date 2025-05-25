# cloudwatch/metric_filter.tf
resource "aws_cloudwatch_log_metric_filter" "iam_policy_delete_filter" {
  name           = "IAMPolicyDelete"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_logs.name
  pattern        = "{ ($.eventName = DeletePolicy) }"

  metric_transformation {
    name      = "IAMPolicyDeleteEventCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}
