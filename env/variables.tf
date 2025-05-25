# 변수의 정의 (Terraform 코드에서 사용할 변수가 어떤 이름인지, 어떤 타입인지, 기본값은 무엇인지를 선언언)

variable "region" {
  default = "ap-northeast-2"
}

variable "email" {
  description = "Email address for SNS subscription"
  type        = string
}

variable "trail_name" {
  description = "CloudTrail trail name"
  type        = string
  default     = "my-cloudtrail"
}

variable "bucket_name" {
  description = "S3 bucket name for storing CloudTrail logs"
  type        = string
  default     = "my-cloudtrail-logs-thswn-unique-2025"
}

variable "log_group_name" {
  description = "Name of the CloudWatch Logs log group"
  type        = string
  default     = "cloudtrail-log-group"
}

variable "alarm_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
  default     = "cloudtrail-security-event-alarm"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for alerting"
  type        = string
  default     = "cloudtrail-alerts-topic"
}
