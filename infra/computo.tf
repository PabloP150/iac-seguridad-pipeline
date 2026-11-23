# Servidor web de la API y su rol de IAM.

resource "aws_iam_role" "web" {
  name = "taskapi-web"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Le dieron admin "mientras tanto" y nunca se lo quitaron
resource "aws_iam_role_policy_attachment" "web_admin" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "web" {
  name = "taskapi-web"
  role = aws_iam_role.web.name
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.subnet_privada_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}
