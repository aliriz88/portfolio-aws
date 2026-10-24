data "archive_file" "counter" {
  type        = "zip"
  source_file = var.lambda_source_file
  output_path = "${path.root}/build/counter.zip"
}

# Only the Lambda service may assume this role
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "counter" {
  name               = "${var.project}-counter-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project}-counter"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.data.arn
}

# Least privilege: one DynamoDB action on one table, the table's key only
# when called through DynamoDB, and writing to its own log group
data "aws_iam_policy_document" "counter" {
  statement {
    sid       = "UpdateCounter"
    actions   = ["dynamodb:UpdateItem"]
    resources = [aws_dynamodb_table.counter.arn]
  }

  statement {
    sid       = "UseTableKeyViaDynamoDB"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = [aws_kms_key.data.arn]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["dynamodb.${local.region}.amazonaws.com"]
    }
  }

  statement {
    sid       = "WriteOwnLogs"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
  }

  # Phase 6: X-Ray tracing (these actions don't support resource-level permissions)
  statement {
    sid       = "XRayTracing"
    actions   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "counter" {
  name   = "counter-least-privilege"
  role   = aws_iam_role.counter.id
  policy = data.aws_iam_policy_document.counter.json
}

resource "aws_lambda_function" "counter" {
  function_name    = "${var.project}-counter"
  description      = "Visitor counter for the ${var.project} site"
  role             = aws_iam_role.counter.arn
  runtime          = "python3.13"
  handler          = "counter.handler"
  filename         = data.archive_file.counter.output_path
  source_code_hash = data.archive_file.counter.output_base64sha256
  timeout          = 5
  memory_size      = 128

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.counter.name
    }
  }

  tracing_config {
    mode = "Active" # Phase 6: X-Ray traces (free tier covers this traffic)
  }

  depends_on = [aws_cloudwatch_log_group.lambda, aws_iam_role_policy.counter]
}
