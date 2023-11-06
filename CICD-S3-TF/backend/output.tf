output "prd-config" {
  value = {
    bucket         = aws_s3_bucket.prd-xuantu_s3_bucket.bucket
    region         = data.aws_region.current.name
    role_arn       = aws_iam_role.iam_role.arn
    dynamodb_table = aws_dynamodb_table.prd-xuantu_dynamodb_table.name
  }
}

# output "stg-config" {
#   value = {
#     bucket         = aws_s3_bucket.nonprd-xuantu_s3_bucket.bucket
#     region         = data.aws_region.current.name
#     role_arn       = aws_iam_role.iam_role.arn
#     dynamodb_table = aws_dynamodb_table.nonprd-xuantu_dynamodb_table.name
#   }
# }