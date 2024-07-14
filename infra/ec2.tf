resource "aws_instance" "web3" {
  ami           = "ami-0a70c5266db4a6202"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = ["${aws_security_group.security.id}"]

  tags = {
    Name = "HelloWorld"
  }
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.default.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.default.private_key_pem
  filename = ".id_rsa"
}
