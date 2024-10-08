# provider "aws" {
#   region = var.region
# }

resource "random_id" "unique" {
  byte_length = 8
}

# Crear la función Lambda con un nombre único
resource "aws_lambda_function" "lambda_service" {
  function_name    = "${var.base_name}-${random_id.unique.hex}-function"
  handler          = var.handler_path
  runtime          = var.runtime # "nodejs20.x"
  filename         = var.filename
  role             = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("${var.filename}")

  environment {
    variables = var.variables
  }
}

# Crear el rol de IAM para Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.base_name}-${random_id.unique.hex}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Política del rol de IAM
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.base_name}-${random_id.unique.hex}-policy"
  role = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "logs:*",
        Effect   = "Allow",
        Resource = "*"
      },
      # {
      #   Action   = "s3:GetObject",
      #   Effect   = "Allow",
      #   Resource = "${aws_s3_bucket.lambda_bucket.arn}/*"
      # }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda_service.arn
}

output "name" {
  value = aws_lambda_function.lambda_service.function_name
}
