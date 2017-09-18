variable "aws_region" {
  default = "ap-northeast-1"
  type    = "string"
}

variable "apex_function_arns" {
  type = "map"
}

variable "rest_api_id" {
  type = "string"
}

variable "resource_id" {
  type = "string"
}

variable "resource_name" {
  type = "string"
}

variable "parent_path_part" {
  type    = "string"
  default = ""
}

variable "http_method" {
  type    = "string"
  default = "GET"
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
