resource "aws_appsync_graphql_api" "main" {
  authentication_type = "AWS_IAM"
  name                = "terraforming-appsync"
  schema              = file("${path.module}/../schema.graphql")
  
  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.graph_log_role.arn
    field_log_level          = "ALL"
    exclude_verbose_content  = false
  }

  additional_authentication_provider {
    authentication_type = "API_KEY"
  }
}

resource "aws_cloudwatch_log_group" "graph" {
  name = "graph"

  tags = {
    application = "graph"
  }
}

### AppSync Wiring to Lambda ###

resource "aws_appsync_datasource" "user_service" {
  api_id           = aws_appsync_graphql_api.main.id
  name             = "user_service"
  service_role_arn = aws_iam_role.appsync_user_service.arn
  type             = "AWS_LAMBDA"

  lambda_config {
    function_arn = aws_lambda_function.user_service.arn
  }
}

resource "aws_appsync_function" "user_service_lambda" {
  api_id                   = aws_appsync_graphql_api.main.id
  data_source              = "user_service"
  name                     = "user_service_lambda"
  request_mapping_template = <<EOF
    {
        "version": "2017-02-28",
        "operation": "Invoke",
        "payload": {
            "command" : "$ctx.info.fieldName",
            "payload" : $utils.toJson({$ctx.args})
        }
    }
  EOF

  response_mapping_template = <<EOF
    $utils.toJson($context.result)
  EOF
}


resource "aws_appsync_resolver" "user_service_lambda_query" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.main.id
  field             = "getUser"
  request_template  = "{}"
  response_template = "$util.toJson($ctx.prev.result)"
  kind              = "PIPELINE"
  pipeline_config {
    functions = [
      aws_appsync_function.user_service_lambda.function_id
    ]
  }
}


resource "aws_appsync_resolver" "user_service_lambda_mutation" {
  type              = "Mutation"
  api_id            = aws_appsync_graphql_api.main.id
  field             = "createUser"
  request_template  = "{}"
  response_template = "$util.toJson($ctx.prev.result)"
  kind              = "PIPELINE"
  pipeline_config {
    functions = [
      aws_appsync_function.user_service_lambda.function_id
    ]
  }
}
