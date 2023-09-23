resource "aws_iam_user" "gh_actions_user" {
  name = "gh-actions-user"
  path = "/"

  tags = {
    terraform = "tf-managed"
  }
}

resource "aws_iam_access_key" "gh_actions_user" {
  user    = aws_iam_user.gh_actions_user.name
}

output "gh_actions_user_secret" {
  value = aws_iam_access_key.gh_actions_user.secret
  sensitive = true
}

output "gh_actions_user_access_key" {
  value = aws_iam_access_key.gh_actions_user.id
}

resource "aws_iam_user_policy" "cicd_user" {
  name = "gh-actions-user"
  user = aws_iam_user.gh_actions_user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": [
            "sts:AssumeRole",
            "sts:TagSession"
        ],
        "Resource": "arn:aws:iam::${var.aws_account}:role/cicd-*"
    }
}
EOF
}
