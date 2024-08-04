resource "aws_ecr_repository" "user_service" {
  name                 = "user_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "null_resource" "ecr_image" {
  triggers = {
    python_file = md5(file("${path.module}/../src/user_service.py"))
    docker_file = md5(file("${path.module}/../Dockerfile"))
  }
  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ap-northeast-3 | docker login --username AWS --password-stdin 211125448588.dkr.ecr.ap-northeast-3.amazonaws.com
      cd ${path.module}/../
      docker build -f Dockerfile -t ${aws_ecr_repository.user_service.repository_url}:latest .
      docker push ${aws_ecr_repository.user_service.repository_url}:latest
    EOF
  }
}

data "aws_ecr_image" "lambda_image" {
  depends_on = [null_resource.ecr_image]
  repository_name = aws_ecr_repository.user_service
  image_tag       = "latest"
}