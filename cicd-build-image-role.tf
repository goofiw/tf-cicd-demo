resource "aws_iam_role" "cicd_build_image" {
  name = "cicd-build-image"
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
      Condition = {}
    }]
    Version = "2012-10-17"
  })

}

resource "aws_iam_role_policy_attachment" "cicd_build_image_AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.cicd_build_image.name
}

resource "aws_iam_role_policy_attachment" "cicd_build_image_AmazonElasticContainerRegistryPublicFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
  role       = aws_iam_role.cicd_build_image.name
}

resource "aws_iam_role_policy_attachment" "cicd_build_image_AmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.cicd_build_image.name
}
