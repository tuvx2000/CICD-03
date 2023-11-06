resource "aws_kms_key" "kms_key" {
  tags = local.tags
}

################### prd-xuantu #################

resource "aws_s3_bucket" "prd-xuantu_s3_bucket" {
  bucket        = "prd-xuantu-s3-backend"
  force_destroy = false

  tags = local.tags
}

resource "aws_s3_bucket_ownership_controls" "prd-xuantu_s3_bucket" {
  depends_on = [aws_s3_bucket.prd-xuantu_s3_bucket]
  bucket     = aws_s3_bucket.prd-xuantu_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "prd-xuantu_s3_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.prd-xuantu_s3_bucket]
  bucket     = aws_s3_bucket.prd-xuantu_s3_bucket.id
  acl        = "private"
}

resource "aws_s3_bucket_versioning" "prd-xuantu_s3_bucket" {
  depends_on = [aws_s3_bucket_acl.prd-xuantu_s3_bucket]
  bucket     = aws_s3_bucket.prd-xuantu_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "prd-xuantu_s3_bucket" {
  bucket = aws_s3_bucket.prd-xuantu_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}

################### stg-xuantu #################

# resource "aws_s3_bucket" "stg-xuantu_s3_bucket" {
#   bucket        = "stg-xuantu-s3-backend"
#   force_destroy = false

#   tags = local.tags
# }

# resource "aws_s3_bucket_ownership_controls" "nonprd-xuantu_s3_bucket" {
#   depends_on = [aws_s3_bucket.nonprd-xuantu_s3_bucket]
#   bucket     = aws_s3_bucket.nonprd-xuantu_s3_bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "nonprd-xuantu_s3_bucket" {
#   depends_on = [aws_s3_bucket_ownership_controls.nonprd-xuantu_s3_bucket]
#   bucket     = aws_s3_bucket.nonprd-xuantu_s3_bucket.id
#   acl        = "private"
# }

# resource "aws_s3_bucket_versioning" "nonprd-xuantu_s3_bucket" {
#   depends_on = [aws_s3_bucket_acl.nonprd-xuantu_s3_bucket]
#   bucket     = aws_s3_bucket.nonprd-xuantu_s3_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "nonprd-xuantu_s3_bucket" {
#   bucket = aws_s3_bucket.nonprd-xuantu_s3_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms"
#       kms_master_key_id = aws_kms_key.kms_key.arn
#     }
#   }
# }