resource "aws_instance" "web" {
  ami           = "ami-0a70c5266db4a6202"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = ["${aws_security_group.security.id}"]

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.default.public_key_openssh
}

