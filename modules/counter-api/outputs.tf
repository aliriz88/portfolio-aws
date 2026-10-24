output "api_url" {
  value = "${aws_apigatewayv2_api.counter.api_endpoint}/count"
}

output "api_id" {
  value = aws_apigatewayv2_api.counter.id
}

output "table_name" {
  value = aws_dynamodb_table.counter.name
}

output "function_name" {
  value = aws_lambda_function.counter.function_name
}

output "kms_key_arn" {
  value = aws_kms_key.data.arn
}
