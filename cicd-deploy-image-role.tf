resource "aws_iam_role" "cicd_deploy_image" {
  name = "cicd-deploy-image"
  max_session_duration = 43200
  tags = {
    terraform = "tf-controlled"
  }

  assume_role_policy = jsonencode({
    Statement = [{
      Action = ["sts:AssumeRole", "sts:TagSession"],
      Effect = "Allow"
      Principal = {
        "AWS": "arn:aws:iam::${var.aws_account}:root"
      }
    }]
    Version = "2012-10-17"
  })

}

# resource "aws_iam_role_policy_attachment" "cicd_deploy_image_AmazonEC2ContainerRegistryFullAccess" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
#   role       = aws_iam_role.cicd_deploy_image.name
# }

# resource "aws_iam_role_policy_attachment" "cicd_deploy_image_AmazonElasticContainerRegistryPublicFullAccess" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
#   role       = aws_iam_role.cicd_deploy_image.name
# }

resource "aws_iam_role_policy_attachment" "cicd_deploy_image_UpdateImageTag" {
  policy_arn = aws_iam_policy.update_image_tag.arn
  role       = aws_iam_role.cicd_deploy_image.name
}

resource "aws_iam_role_policy_attachment" "cicd_deploy_image_HelmDeploy" {
  policy_arn = aws_iam_policy.helm_deploy.arn
  role       = aws_iam_role.cicd_deploy_image.name
}

resource "aws_iam_role_policy_attachment" "cicd_deploy_image_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cicd_deploy_image.name
}


resource "aws_iam_policy" "update_image_tag" {
  name        = "UpdateImageTag"
  path        = "/"
  description = "Allow updating image tags"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action   = ["ecr:PutImage", "ecr:BatchGetImage"]
        Resource = ["*"]
      },
    ]
  })
}

resource "aws_iam_policy" "helm_deploy" {
  name        = "HelmDeploy"
  path        = "/"
  description = "Allow doing helm deploy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action   = ["eks:DescribeCluster"]
        Resource = ["*"]
      },
    ]
  })
}
