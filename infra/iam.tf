### Lambda ###


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

resource "aws_iam_role_policy_attachment" "lambda_policy_add" {
  role       = aws_iam_role.lambda_user_service.name
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


### Lambda & DynamoDB ###


resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name   = "dynamodb-lambda-policy"
  role   = aws_iam_role.lambda_user_service.id
  policy = data.aws_iam_policy_document.dynamodb_lambda_policy.json
}

data "aws_iam_policy_document" "dynamodb_lambda_policy" {
  statement {
    actions   = ["dynamodb:*"]
    effect    = "Allow"
    resources = [aws_dynamodb_table.user_profiles.arn]
  }
}


### AppSync Wiring to Lambda ###


resource "aws_iam_role" "appsync_user_service" {
  name = "appsync-user-service-role"

  assume_role_policy = data.aws_iam_policy_document.appsync_user_service.json
}

data "aws_iam_policy_document" "appsync_user_service" {
  statement {
    sid = "1"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "appsync_user_service_doc" {
  statement {
    sid = "1"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [aws_lambda_function.user_service.arn]
  }
}

resource "aws_iam_role_policy" "appsync_user_service" {
  name   = "appsync_user_service_role_policy"
  role   = aws_iam_role.appsync_user_service.id
  policy = data.aws_iam_policy_document.appsync_user_service_doc.json
}


### AppSync CloudWatch ###


data "aws_iam_policy_document" "graph_log_role" {
  statement {
    sid = "1"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }

}

resource "aws_iam_role" "graph_log_role" {
  name = "graph_log_role"

  assume_role_policy = data.aws_iam_policy_document.graph_log_role.json
}

data "aws_iam_policy_document" "graph_log_policy" {
  statement {
    sid = "1"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "graph_log" {
  name   = "graph_log_policy"
  role   = aws_iam_role.graph_log_role.id
  policy = data.aws_iam_policy_document.graph_log_policy.json
}