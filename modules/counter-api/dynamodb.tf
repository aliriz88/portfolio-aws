resource "aws_dynamodb_table" "counter" {
  name         = "${var.project}-visitor-count"
  billing_mode = "PAY_PER_REQUEST" # on-demand: nothing to size, pennies at this scale
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.data.arn
  }

  point_in_time_recovery {
    enabled = true # restore to any second in the last 35 days
  }
}
