resource "aws_lambda_function" "user_service" {

  function_name = "user_service"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.user_service.repository_url}:latest"
  role          = aws_iam_role.lambda_user_service.arn
  publish       = true

  memory_size = 128
  timeout     = 28

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_cloudwatch_log_group" "lambda_user_service" {
  name              = "/aws/lambda/lambda_user_service"
  retention_in_days = 7
}