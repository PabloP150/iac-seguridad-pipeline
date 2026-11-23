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

# Solo lo necesario para administrar la instancia con Systems Manager
resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.web.name

  # IMDSv2 obligatorio: el token evita que un SSRF lea las credenciales del rol
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
    kms_key_id  = aws_kms_key.taskapi.arn
  }
}
