terraform {
    required_version = ">= 0.12.7"
    required_providers {
        aws = {
        source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    profile = "default"
    region = "${var.region}"
}


resource "aws_s3_bucket" "labbucket" {
  bucket = "tf-lab-1-bucket"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "allow_access_for_specific_user" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access_for_specific.json
}

data "aws_iam_policy_document" "allow_access_for_specific_user" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${var.account}"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}