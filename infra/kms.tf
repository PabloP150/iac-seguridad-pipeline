# Llave propia (CMK) para cifrar el disco del servidor y la base de datos.

data "aws_caller_identity" "actual" {}

resource "aws_kms_key" "taskapi" {
  description             = "Cifrado de datos de la API de tareas (EBS y RDS)"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AdministracionDesdeLaCuenta"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.actual.account_id}:root" }
      Action    = "kms:*"
      Resource  = "*"
    }]
  })
}

resource "aws_kms_alias" "taskapi" {
  name          = "alias/taskapi-datos"
  target_key_id = aws_kms_key.taskapi.key_id
}
