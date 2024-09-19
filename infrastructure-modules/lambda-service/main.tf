terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.13"

}

#create the iam role for lambda
resource "aws_iam_role" "lambda_role" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json

}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# create the lambda function
resource "aws_lambda_function" "terragrunt_lambda" {
  function_name = var.name
  role          = aws_iam_role.lambda_role.arn

  package_type     = "Zip"
  filename         = data.archive_file.source_code.output_path
  source_code_hash = data.archive_file.source_code.output_base64sha256

  runtime     = var.runtime
  handler     = var.handler
  memory_size = var.memory_size
  timeout     = var.timeout

}


# create the archive file
data "archive_file" "source_code" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/{var.name}.zip"
}

#Create an Http API Gateway to send requests to the lambda function

resource "aws_apigatewayv2_api" "http_api" {
  name          = var.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

}

#create routing for the function

resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.terragrunt_lambda.arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# create the permission for the lambda function to be invoked by the api gateway
resource "aws_lambda_permission" "allow_invoke" {
  statement_id  = "AllowAPIGateway${var.name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terragrunt_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/${local.route_key_method}${local.route_key_path}"

}

locals {
  route_key_parts  = split("", var.route_key)
  route_key_method = local.route_key_parts[0]
  route_key_path   = local.route_key_parts[1]
}
