# Create role for lambda
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "budget_lambda_role" {
  name               = "budget_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "budget_policy" {
  role       = aws_iam_role.budget_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Grab lambda src code
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/budget-handler"
  output_path = "${path.root}/modules/lambdas/budget_lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.root}/modules/lambdas/budget_lambda.zip"
  handler       = "main.handler"
  role          = aws_iam_role.budget_lambda_role.arn
  function_name = var.lambda_name
  description   = var.lambda_description
  runtime       = "python3.12"

  environment {
    variables = {
      foo = "bar"
    }
  }
}