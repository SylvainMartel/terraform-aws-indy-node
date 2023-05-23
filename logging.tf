resource "aws_flow_log" "candy_flow" {
  iam_role_arn    = aws_iam_role.candy_flow.arn
  log_destination = aws_cloudwatch_log_group.candy_flow.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.node_vpc.id
}

resource "aws_cloudwatch_log_group" "candy_flow" {
  name = "candy-flow"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "candy_flow" {
  name               = "candy_flow_logging"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "candy_flow" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "candy_flow" {
  name   = "candy_flow_pol"
  role   = aws_iam_role.candy_flow.id
  policy = data.aws_iam_policy_document.candy_flow.json
}
