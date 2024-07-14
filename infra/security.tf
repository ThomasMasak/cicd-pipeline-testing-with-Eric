resource "aws_security_group" "security" {
  name = "allow-all"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
