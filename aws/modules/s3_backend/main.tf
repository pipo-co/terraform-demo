resource "aws_s3_bucket" "state" {
  bucket_prefix = "state"
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "bucket" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.state.arn}"]

    principals {
      type        = "AWS"
      identifiers = var.authorized_IAM_arn
    }
  }
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.state.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = var.authorized_IAM_arn
    }
  }
}

resource "aws_s3_bucket_policy" "state" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.bucket.json
}
