data "archive_file" "init" {
  type        = "zip"
  source_dir  = "${path.module}/code"
  output_path = "${path.module}/dist/lambda.zip"
}

resource "aws_lambda_function" "lambda_processor" {
  depends_on       = ["data.archive_file.init"]
  filename         = "dist/lambda.zip"
  function_name    = "dynamodb_to_kinesis_stream"
  role             = "${aws_iam_role.lambda_iam.arn}"
  handler          = "exports.handler"
  runtime          = "python3.6"
  source_code_hash = "${base64sha256(file("${path.module}/dist/lambda.zip"))}"

  tags {
    AppDefined01 = "MFT"
  }
}

variable stream {
  default = "/stream/"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  depends_on        = ["aws_lambda_function.lambda_processor"]
  batch_size        = 10
  event_source_arn  = "${aws_dynamodb_table.basic-dynamodb-table.stream_arn}"
  enabled           = true
  function_name     = "${aws_lambda_function.lambda_processor.arn}"
  starting_position = "LATEST"
}

resource "aws_iam_role" "lambda_iam" {
  name = "lambda_iam"

  assume_role_policy = "${file("lambda-assume-role.json")}"
}

resource "aws_iam_policy" "pol-lambda" {
  name        = "pol-lambda"
  path        = "/"
  description = "Policy for Lambda access"
  policy      = "${file("lambda-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "lambda-attach" {
  role       = "${aws_iam_role.lambda_iam.name}"
  policy_arn = "${aws_iam_policy.pol-lambda.arn}"
}
