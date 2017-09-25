data "aws_caller_identity" "current" {}

resource "aws_api_gateway_method" "method" {
  authorization = "${var.authorization}"
  http_method   = "${var.http_method}"
  resource_id   = "${var.resource_id}"
  rest_api_id   = "${var.rest_api_id}"
}

resource "aws_api_gateway_method_response" "method_response" {
  http_method = "${aws_api_gateway_method.method.http_method}"
  resource_id = "${var.resource_id}"

  response_models = {
    "application/json" = "Empty"
  }

  rest_api_id = "${var.rest_api_id}"
  status_code = "${var.status_code}"
}

resource "aws_api_gateway_integration" "integration" {
  content_handling        = "${var.content_handling}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "${var.integration_http_method}"
  passthrough_behavior    = "${var.passthrough_behavior}"
  resource_id             = "${var.resource_id}"
  rest_api_id             = "${var.rest_api_id}"
  request_templates       = "${var.request_templates}"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${lookup(var.apex_function_arns, format("%s_%s",lower(var.http_method),var.parent_path_part == "" ? var.resource_name  : format("%s_%s",var.parent_path_part,var.resource_name)))}/invocations"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  http_method = "${aws_api_gateway_method.method.http_method}"
  resource_id = "${var.resource_id}"
  rest_api_id = "${var.rest_api_id}"

  status_code = "${aws_api_gateway_method_response.method_response.status_code}"
}

resource "aws_lambda_permission" "permission_allow_api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = "${lookup(var.apex_function_arns, format("%s_%s",lower(var.http_method),var.parent_path_part == "" ? var.resource_name  : format("%s_%s",var.parent_path_part,var.resource_name)))}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${var.rest_api_id}/*/${var.http_method}/${var.parent_path_part == "" ? ""  : format("%s/",var.parent_path_part)}${var.resource_name}"
  statement_id  = "AllowExecutionFromAPIGateway"
}
