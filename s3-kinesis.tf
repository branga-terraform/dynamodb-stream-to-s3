resource "aws_s3_bucket" "s3bucket" {
  bucket = "rangarb-sbx-bucket"
  acl    = "public-read-write"

  tags {
    AppDefined01 = "MFT"
  }
}

resource "aws_cloudwatch_log_group" "loggroup" {
  name = "mft-kinesis-firehose-test-stream-log-group"
  tags {
    AppDefined01 = "MFT"
  }
}

resource "aws_cloudwatch_log_stream" "logstream" {
  name           = "mft-kinesis-firehose-test-stream-log-stream"
  log_group_name = "${aws_cloudwatch_log_group.loggroup.name}"
}

resource "aws_kinesis_firehose_delivery_stream" "mft_firehouse_delivery_stream" {
  depends_on  = ["aws_s3_bucket.s3bucket"]
  name        = "mft-kinesis-firehose-test-stream"
  destination = "s3"

  s3_configuration {
    role_arn   = "${aws_iam_role.firehose_role.arn}"
    bucket_arn = "${aws_s3_bucket.s3bucket.arn}"
    prefix     = "dynamodbstreams/${aws_dynamodb_table.basic-dynamodb-table.name}/"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "${aws_cloudwatch_log_group.loggroup.name}"
      log_stream_name = "${aws_cloudwatch_log_stream.logstream.name}"
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
