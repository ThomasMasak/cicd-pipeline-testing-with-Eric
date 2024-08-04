resource "aws_ecr_repository" "user_service" {
  name                 = "user_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "null_resource" "ecr_image" {
  triggers = {
    python_file = md5(file("../src/user_service.py"))
    docker_file = md5(file("../Dockerfile"))
  }
}

data "aws_ecr_image" "lambda_image" {
  depends_on = [null_resource.ecr_image]
  repository_name = aws_ecr_repository.user_service
  image_tag       = "latest"
}