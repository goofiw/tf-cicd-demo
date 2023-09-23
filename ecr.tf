resource "aws_ecr_repository" "cicd-demo" {
  name                 = "cicd-demo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
