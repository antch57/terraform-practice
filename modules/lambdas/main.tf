# Lambda permissions
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

resource "aws_iam_policy" "budget_lambda_secret_manager_policy" {
  name = "budget_lambda_secret_manager"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = "*" # FIXME: change to specific secret
      },
    ]
  })
}

resource "aws_iam_role" "budget_lambda_role" {
  name               = "budget_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "budget_lambda_policy" {
  role       = aws_iam_role.budget_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "budget_lambda_vpc_access" {
  role       = aws_iam_role.budget_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "budget_lambda_secret_manager_attach" {
  role       = aws_iam_role.budget_lambda_role.name
  policy_arn = aws_iam_policy.budget_lambda_secret_manager_policy.arn
}

# FIXME: fix this so it bundles the python package correctly
# Grab lambda src code
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/budget-handler"
  output_path = "${path.root}/modules/lambdas/budget_lambda.zip"
}

# security group for lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
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

# TODO: figure out how to zip lambda code
# TODO: pass secrets manager arn to lambda
resource "aws_lambda_function" "test_lambda" {
  filename         = "${path.root}/lambdas/budget-handler/budget_lambda.zip"
  handler          = "main.handler"
  role             = aws_iam_role.budget_lambda_role.arn
  function_name    = var.lambda_name
  description      = var.lambda_description
  runtime          = "python3.12"
  timeout          = 10
  source_code_hash = data.archive_file.lambda.output_base64sha256

  vpc_config {
    subnet_ids         = data.aws_subnets.existing_subnets.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      RDS_HOSTNAME = var.rds_hostname
    }
  }
}