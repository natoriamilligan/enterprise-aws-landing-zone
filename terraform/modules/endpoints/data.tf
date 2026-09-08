data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecr_endpoint_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/task-execution-role"
      ]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }
}
