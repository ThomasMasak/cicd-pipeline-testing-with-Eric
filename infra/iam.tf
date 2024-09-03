resource "aws_iam_role" "iam_lambda_user_service" {
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

resource "aws_iam_role_policy_attachment" "lambda_policy_add" {
  role       = aws_iam_role.iam_lambda_user_service.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda-user-service-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
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

resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name   = "dynamodb-lambda-policy"
  role   = aws_iam_role.iam_lambda_user_service.id
  policy = data.aws_iam_policy_document.dynamodb_lambda_policy.json
  }

data "aws_iam_policy_document" "dynamodb_lambda_policy" {
  statement {
    actions = ["dynamodb:*"]
    effect    = "Allow"
    resources = [aws_dynamodb_table.user_profiles.arn]
  }
}
