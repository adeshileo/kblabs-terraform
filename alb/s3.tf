resource "aws_s3_bucket" "lb_logs" {
  bucket = "kblabs-test-lb-logs"

  tags = {
    Environment = "dev"
  }
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "lb_logs" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.lb_logs.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  policy = data.aws_iam_policy_document.lb_logs.json
}
