variable "aws_region" {
  default = "ap-northeast-1"
  type    = "string"
}

variable "apex_function_arns" {
  type = "map"
}

variable "lambda_function_name" {
  type    = "string"
  default = ""
}

variable "rest_api_id" {
  type = "string"
}

variable "resource_id" {
  type = "string"
}

variable "resource_path" {
  type = "string"
}

variable "http_method" {
  type    = "string"
  default = "GET"
}

variable "integration_http_method" {
  type    = "string"
  default = "POST"
}

variable "status_code" {
  type    = "string"
  default = "200"
}

variable "authorization" {
  type    = "string"
  default = "NONE"
}

variable "content_handling" {
  type    = "string"
  default = "CONVERT_TO_TEXT"
}

variable "request_templates" {
  type    = "map"
  default = {}
}

variable "passthrough_behavior" {
  type    = "string"
  default = "WHEN_NO_TEMPLATES"
}

locals {
  lambda_function_name = "${lookup(var.apex_function_arns, var.lambda_function_name)}"
}
