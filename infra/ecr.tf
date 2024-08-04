data "aws_ecr_authorization_token" "token" {}

resource "aws_ecr_repository" "user_service" {
  name                 = "user_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  
  # lifecycle {
  #     ignore_changes = all
  #   }

  provisioner "local-exec" {
    command = <<-EOF
          docker build ../ -t ${aws_ecr_repository.user_service.repository_url}:latest; \
          docker login -u AWS -p ${data.aws_ecr_authorization_token.token.password} ${data.aws_ecr_authorization_token.token.proxy_endpoint}; \
          docker push ${aws_ecr_repository.user_service.repository_url}:latest
        EOF
  }
}