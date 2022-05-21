resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  runtime          = "nodejs12.x"
  handler          = "index.handler"
  role             = aws_iam_role.this.arn
  filename         = data.archive_file.archive.output_path
  source_code_hash = data.archive_file.archive.output_base64sha256
  publish          = true
}

resource "aws_iam_role" "lambda_role" {
  name               = format("%s-role", var.function_name)
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_exec_role_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = format("%s-policy", var.function_name)
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_exec_role_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_permission" "allow_cloudfront" {
  function_name = aws_lambda_function.lambda_function.function_name
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:GetFunction"
  principal     = "edgelambda.amazonaws.com"
}

data "archive_file" "archive" {
  type        = "zip"
  source_file = "index.js"
  output_path = "index.zip"
}