provider "aws" {
  region = var.region
}

module "bucket" {
  source      = "./bucket"
  bucket_name = var.bucket_name
}

module "cloudwatch" {
  source          = "./cloudwatch"
  log_group_name  = var.log_group_name
  alarm_name      = var.alarm_name
  email           = var.email
}

module "cloudtrail" {
  source                = "./cloudtrail"
  trail_name            = var.trail_name
  bucket_name           = module.bucket.bucket_name
  log_group_arn         = module.cloudwatch.log_group_arn
  role_arn              = module.cloudtrail.role_arn
}

module "sns" {
  source         = "./sns"
  topic_name     = var.sns_topic_name
  subscription_email = var.email
}
