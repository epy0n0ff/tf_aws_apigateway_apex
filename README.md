tf\_aws\_apigateway\_apex
===========
A terraform module to provide apigateway-apex integration easily.


Usage
-----
```
# Create  a rest api
resource "aws_api_gateway_rest_api" "test-rest-api" {
  name = "test-rest-api"
}

# Create a resource for use this module
resource "aws_api_gateway_resource" "fiends" {
  rest_api_id = "${aws_api_gateway_rest_api.test-rest-api.id}"
  parent_id   = "${aws_api_gateway_rest_api.test-rest-api.root_resource_id}"
  path_part   = "fiends"
}

resource "aws_api_gateway_resource" "fiends_chat" {
  rest_api_id = "${aws_api_gateway_rest_api.test-rest-api.id}"
  parent_id   = "${aws_api_gateway_resource.fiends.id}"
  path_part   = "answer"
}

# Use this module
module "fiends" {
  source             = "github.com/epy0n0ff/tf_aws_apigateway_apex"
  resource_name      = "fiends"
  http_method        = "POST"
  resource_id        = "${aws_api_gateway_resource.fiends.id}"
  rest_api_id        = "${aws_api_gateway_rest_api.test-rest-api.id}"
  apex_function_arns = "${var.apex_function_arns}"

  request_templates = {
    "application/x-www-form-urlencoded" = <<EOF
##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
},
"stage-variables" : {
#foreach($key in $stageVariables.keySet())
"$key" : "$util.escapeJavaScript($stageVariables.get($key))"
    #if($foreach.hasNext),#end
#end
},
"context" : {
    "account-id" : "$context.identity.accountId",
    "api-id" : "$context.apiId",
    "api-key" : "$context.identity.apiKey",
    "authorizer-principal-id" : "$context.authorizer.principalId",
    "caller" : "$context.identity.caller",
    "cognito-authentication-provider" : "$context.identity.cognitoAuthenticationProvider",
    "cognito-authentication-type" : "$context.identity.cognitoAuthenticationType",
    "cognito-identity-id" : "$context.identity.cognitoIdentityId",
    "cognito-identity-pool-id" : "$context.identity.cognitoIdentityPoolId",
    "http-method" : "$context.httpMethod",
    "stage" : "$context.stage",
    "source-ip" : "$context.identity.sourceIp",
    "user" : "$context.identity.user",
    "user-agent" : "$context.identity.userAgent",
    "user-arn" : "$context.identity.userArn",
    "request-id" : "$context.requestId",
    "resource-id" : "$context.resourceId",
    "resource-path" : "$context.resourcePath"
    }
}
EOF
  }
}

# Create a sub-resource for use this module
module "fiends_chat" {
  source             = "github.com/epy0n0ff/tf_aws_apigateway_apex"
  resource_name      = "chat"
  parent_path_part   = "${aws_api_gateway_resource.fiends.path_part}"
  http_method        = "POST"
  resource_id        = "${aws_api_gateway_resource.fiends_chat.id}"
  rest_api_id        = "${aws_api_gateway_rest_api.test-rest-api.id}"
  apex_function_arns = "${var.apex_function_arns}"

  request_templates = {
    "application/x-www-form-urlencoded" = <<EOF
##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload
#set($allParams = $input.params())
{
"body-json" : $input.json('$'),
"params" : {
#foreach($type in $allParams.keySet())
    #set($params = $allParams.get($type))
"$type" : {
    #foreach($paramName in $params.keySet())
    "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
        #if($foreach.hasNext),#end
    #end
}
    #if($foreach.hasNext),#end
#end
},
"stage-variables" : {
#foreach($key in $stageVariables.keySet())
"$key" : "$util.escapeJavaScript($stageVariables.get($key))"
    #if($foreach.hasNext),#end
#end
},
"context" : {
    "account-id" : "$context.identity.accountId",
    "api-id" : "$context.apiId",
    "api-key" : "$context.identity.apiKey",
    "authorizer-principal-id" : "$context.authorizer.principalId",
    "caller" : "$context.identity.caller",
    "cognito-authentication-provider" : "$context.identity.cognitoAuthenticationProvider",
    "cognito-authentication-type" : "$context.identity.cognitoAuthenticationType",
    "cognito-identity-id" : "$context.identity.cognitoIdentityId",
    "cognito-identity-pool-id" : "$context.identity.cognitoIdentityPoolId",
    "http-method" : "$context.httpMethod",
    "stage" : "$context.stage",
    "source-ip" : "$context.identity.sourceIp",
    "user" : "$context.identity.user",
    "user-agent" : "$context.identity.userAgent",
    "user-arn" : "$context.identity.userArn",
    "request-id" : "$context.requestId",
    "resource-id" : "$context.resourceId",
    "resource-path" : "$context.resourcePath"
    }
}
EOF
  }
}
```

```
$ terraform get
$ apex infra apply
```