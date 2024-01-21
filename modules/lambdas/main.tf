# Lambda permissions
data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_secret_manager" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.rds_secret_arn]
  }
}

resource "aws_iam_role" "lambda_1_role" {
  name               = "lambda_1_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json

  inline_policy {
    name   = "lambda_1_secret_manager_policy"
    policy = data.aws_iam_policy_document.lambda_secret_manager.json
  }
}

resource "aws_iam_role_policy_attachment" "budget_lambda_policy" {
  role       = aws_iam_role.lambda_1_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "budget_lambda_vpc_access" {
  role       = aws_iam_role.lambda_1_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# security group for lambda
resource "aws_security_group" "lambda_1_sg" {
  name        = "lambda_1_sg"
  description = "Security group for lambda"
  vpc_id      = var.vpc_id
}

# grab subnets
data "aws_subnets" "existing_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# FIXME: auto package python dependencies and src code
# TODO: pip install -r requirements.txt -t package/ && cp main.py package/ && cd package/ && zip -r ../budget_lambda.zip .
data "archive_file" "name" {
  source_dir  = "${path.root}/lambdas/budget-handler/package"
  output_path = "${path.root}/lambdas/budget-handler/budget_lambda.zip"
  type        = "zip"
}

resource "aws_lambda_function" "lambda_1" {
  filename         = data.archive_file.name.output_path
  handler          = "main.handler"
  role             = aws_iam_role.lambda_1_role.arn
  function_name    = var.lambda_name
  description      = var.lambda_description
  runtime          = "python3.12"
  timeout          = 10
  source_code_hash = data.archive_file.name.output_base64sha256

  vpc_config {
    subnet_ids         = data.aws_subnets.existing_subnets.ids
    security_group_ids = [aws_security_group.lambda_1_sg.id]
  }

  environment {
    variables = {
      RDS_HOSTNAME   = var.rds_hostname
      RDS_SECRET_ARN = var.rds_secret_arn
    }
  }
}