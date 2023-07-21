



resource "aws_cloudwatch_event_target" "this" {
  count = var.restore_db ? 1 : 0
  arn   = aws_lambda_function.this[0].arn
  rule  = aws_cloudwatch_event_rule.this[0].id
  input_transformer {
    input_paths = {
      "DB_ID" : "$.detail.SourceIdentifier"
    }
    input_template = <<EOF
{
  "DB_ID": <DB_ID>
}
EOF
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  count         = var.restore_db ? 1 : 0
  name          = "${var.env_code}-creation-db-rule"
  description   = "Capture creation of rds db instance"
  event_pattern = <<PATTERN
  {
    "source" : ["aws.rds"],
    "detail-type" : ["RDS DB Instance Event"],
    "detail" : {
      "EventID" : ["RDS-EVENT-0005"]
    }
  }
PATTERN
}
