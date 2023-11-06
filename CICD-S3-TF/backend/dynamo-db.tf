locals {
  tag = {
    project = var.project
  }
}

resource "aws_dynamodb_table" "prd-xuantu_dynamodb_table" {
  name = "prd-xuantu-s3-backend"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "${var.project}-s3-backend"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}




# resource "aws_dynamodb_table" "nonprd-xuantu_dynamodb_table" {
#   name = "nonprd-xuantu-s3-backend"

#   hash_key     = "LockID"
#   billing_mode = "PAY_PER_REQUEST"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = local.tags
# }
