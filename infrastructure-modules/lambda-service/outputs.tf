output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint

}

output "api_id" {
  value = aws_apigatewayv2_api.http_api.id

}

output "api_stage_id" {
  value = aws_apigatewayv2_stage.default.id

}

output "lambda_arn" {
  value = aws_lambda_function.terragrunt_lambda.arn

}
