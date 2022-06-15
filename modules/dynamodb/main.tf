resource "aws_dynamodb_table" "studentstable" {
  attribute {
    name = "studentID"
    type = "S"
  }
  attribute {
    name = "name"
    type = "S"
  }
  hash_key     = "studentID"
  range_key    = "name"
  billing_mode = "PAY_PER_REQUEST"
  name         = var.table_name
}
