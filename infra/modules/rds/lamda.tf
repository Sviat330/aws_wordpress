
#Archieve folder that contain
data "archive_file" "python_lambda_package" {
  count       = var.restore_db ? 1 : 0
  type        = "zip"
  output_path = "lambda_function.zip"
  source_file = "${path.module}/code/lambda_function.py"
}

#Lambda function that will create ec2 instance by trigger 
resource "aws_lambda_function" "this" {
  count            = var.restore_db ? 1 : 0
  function_name    = "${var.env_code}-lambda-for-restore-db"
  filename         = "lambda_function.zip"
  role             = aws_iam_role.lambda_role[0].arn
  source_code_hash = data.archive_file.python_lambda_package[0].output_base64sha256
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.10"
  environment {
    variables = {
      SUBNET_ID       = "${var.public_subnet_ids[0]}",
      DB_USERNAME     = "${var.db_username}",
      DB_PORT         = var.db_port,
      DB_PASS         = var.pass,
      DB_NAME         = var.db_name,
      REGION          = data.aws_region.current.name,
      InstanceProfile = aws_iam_instance_profile.this[0].arn
      DB_HOST         = aws_db_instance.this.address
    }
  }
  layers = [aws_lambda_layer_version.this[0].arn]
  vpc_config {
    subnet_ids         = [var.public_subnet_ids[0], var.public_subnet_ids[1]]
    security_group_ids = [aws_security_group.db_sg.id]
  }

}


resource "aws_lambda_layer_version" "this" {
  count            = var.restore_db ? 1 : 0
  layer_name       = var.lambda_layer_name
  filename         = "${path.module}/code/mysql.zip"
  source_code_hash = "${path.module}/code/mysql.zip"
}

variable "lambda_layer_name" {
  description = "Name for lambda layer"
  default     = "pymysql"
}
