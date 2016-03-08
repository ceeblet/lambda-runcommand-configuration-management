# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
# except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under the License.

# Lambda Role with Required Policy
resource "aws_iam_role_policy" "lambda_policy" {
    name = "garlc_policy"
    role = "${aws_iam_role.lambda_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
    name = "garlc_lambda_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
output "lambda_role_arn" {
  value = "${aws_iam_role.lambda_role.name}"
}

# Lambda Function
resource "aws_lambda_function" "lambda_function" {
    filename = "lambda_function_payload.zip"
    function_name = "garlc"
    role = "${aws_iam_role.lambda_role.arn}"
    handler = "main.handle"
    description = "Continuous Configuration Management"
    memory_size = 128
    runtime = "python2.7"
    timeout = 5
    # this will be released soon
    # https://github.com/hashicorp/terraform/pull/5239
    # source_code_hash = "${base64encode(sha256(file("lambda_function_payload.zip")))}"
}
