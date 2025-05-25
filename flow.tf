provider "aws" {
  region = "ap-northeast-2"
}

# 현재 AWS 계정 ID
data "aws_caller_identity" "current" {}

# CloudWatch 로그 그룹
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail-log-group"
}

# IAM Role for CloudTrail → CloudWatch
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-to-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "cloudwatch-logs-permission"

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
        }
      ]
    })
  }
}

# IAM Policy attach
resource "aws_iam_role_policy_attachment" "cloudtrail_logs" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess"
}

# CloudTrail 로그 저장용 S3 버킷
resource "aws_s3_bucket" "trail_bucket" {
  bucket         = "my-cloudtrail-logs-thswn-unique-2025"  # 고유하게 유지
  force_destroy  = true
}

# 로컬 변수: 외부 JSON 템플릿을 동적으로 읽기
locals {
  bucket_policy = templatefile("${path.module}/bucket-policy.json.tpl", {
    bucket_name = aws_s3_bucket.trail_bucket.bucket
    account_id  = data.aws_caller_identity.current.account_id
  })
}

# S3 Bucket Policy 적용
resource "aws_s3_bucket_policy" "trail_policy" {
  bucket = aws_s3_bucket.trail_bucket.id
  policy = local.bucket_policy
}

# CloudTrail 생성
resource "aws_cloudtrail" "my_trail" {
  name                          = "my-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
}

