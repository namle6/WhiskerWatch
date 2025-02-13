terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "food_images" {
  bucket = "food-monitoring-images"
}

resource "aws_s3_bucket_versioning" "food-image" {
  bucket = aws_s3_bucket.food_images.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "lamda_role" {
  name = "food_monitoring_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lamda_policy" {
  name = "food_monitoring_lambda_policy"
  role = aws_iam_role.lamda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "${aws_s3_bucket.food_images.arn}/*",
          "arn:aws:logs:*:*:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "rekognition:DetectLabels"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "food_monitoring" {
  filename      = "lambda_function.zip"
  function_name = "food_monitoring"
  role          = aws_iam_role.lamda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = {
      TWILIO_ACCOUNT_SID = var.twilio_account_sid
      TWILIO_AUTH_TOKEN  = var.twilio_auth_token
      TWILIO_PHONE_FROM  = var.twilio_phone_from
      TWILIO_PHONE_TO    = var.twilio_phone_to
    }
  }
}

# Added Lambda permission to allow S3 to invoke the function
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.food_monitoring.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.food_images.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.food_images.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.food_monitoring.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}

variable "twilio_account_sid" {
  description = "Twilio Account SID"
  type        = string
}

variable "twilio_auth_token" {
  description = "Twilio Auth Token"
  type        = string
}

variable "twilio_phone_from" {
  description = "Twilio Phone Number From"
  type        = string
}

variable "twilio_phone_to" {
  description = "Twilio Phone Number To"
  type        = string
}