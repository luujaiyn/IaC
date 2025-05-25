# CloudTrail 생성하고, S3에 로그 저장하고, CloudWatch Logs로도 전송, 이벤트 기록 설정, 

resource "aws_cloudtrail" "my_trail" {
  name                          = "my-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"

  event_selector {
    read_write_type = "All"
  }

  depends_on = [
    aws_cloudwatch_log_group.cloudtrail_logs,
    aws_s3_bucket_policy.trail_policy
  ]
}
