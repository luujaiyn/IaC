# sns 주제 생성 및 이메일 구독

resource "aws_sns_topic" "cloudtrail_alerts" {
  name = "cloudtrail-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cloudtrail_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
