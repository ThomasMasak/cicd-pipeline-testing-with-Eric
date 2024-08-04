resource "aws_ecr_repository" "user_service" {
  name                 = "user_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}