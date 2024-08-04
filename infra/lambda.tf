resource "aws_lambda_function" "user_service" {

  function_name = "user_service"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.user_service.repository_url}:latest"
  role          = aws_iam_role.lambda_user_service.arn
  publish       = true

  memory_size = 128
  timeout     = 28

  lifecycle {
    ignore_changes = [
      image_uri, last_modified
    ]
  }
}

resource "aws_cloudwatch_log_group" "lambda_user_service" {
  name              = "/aws/lambda/lambda_user_service"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda_user_service" {
  name               = "lambda-user-service-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_user_service_assume.json
}

data "aws_iam_policy_document" "lambda_user_service_assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "user_service" {
  role       = aws_iam_role.lambda_user_service.name
  policy_arn = aws_iam_policy.lambda_user_service_custom.arn
}

resource "aws_iam_policy" "lambda_user_service_custom" {
  name   = "lambda-user-service-policy"
  policy = data.aws_iam_policy_document.lambda_user_service_custom.json
}

data "aws_iam_policy_document" "lambda_user_service_custom" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "CreateCloudWatchLogs"
  }
}
