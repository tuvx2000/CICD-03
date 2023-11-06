locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [
    "arn:aws:iam::055475569617:user/sub.tu.vo"
  ]
  tags = {
    project = var.project
  }
}

data "aws_iam_policy_document" "prd-xuantu_policy_doc" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.prd-xuantu_s3_bucket.arn]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.prd-xuantu_s3_bucket.arn}/*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = [aws_dynamodb_table.prd-xuantu_dynamodb_table.arn]
  }
}

# data "aws_iam_policy_document" "nonprd-xuantu_policy_doc" {
#   statement {
#     actions   = ["s3:ListBucket"]
#     resources = [aws_s3_bucket.nonprd-xuantu_s3_bucket.arn]
#   }

#   statement {
#     actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
#     resources = ["${aws_s3_bucket.nonprd-xuantu_s3_bucket.arn}/*"]
#   }

#   statement {
#     actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
#     resources = [aws_dynamodb_table.nonprd-xuantu_dynamodb_table.arn]
#   }
# }

resource "aws_iam_policy" "prd-xuantu_policy" {
  name   = "prd-xuantu-TerraformS3BackendPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.prd-xuantu_policy_doc.json
}

# resource "aws_iam_policy" "nonprd-xuantu_policy" {
#   name   = "nonprd-xuantu-TerraformS3BackendPolicy"
#   path   = "/"
#   policy = data.aws_iam_policy_document.nonprd-xuantu_policy_doc.json
# }

resource "aws_iam_role" "iam_role" {
  name = "${title(var.project)}TerraformS3BackendRole"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
        "AWS": ${jsonencode(local.principal_arns)}
      },
      "Effect": "Allow"
      }
    ]
  }
  EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "prd-xuantu_policy_attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.prd-xuantu_policy.arn
}

# resource "aws_iam_role_policy_attachment" "nonprd-xuantu_policy_attach" {
#   role       = aws_iam_role.iam_role.name
#   policy_arn = aws_iam_policy.nonprd-xuantu_policy.arn
# }