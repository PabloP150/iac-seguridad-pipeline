# Base de datos PostgreSQL de la API.

resource "aws_db_instance" "app" {
  # EXCEPCIÓN DOCUMENTADA (la única del repo)
  # Multi-AZ no se activa porque esta base es de staging: duplica el costo y el riesgo
  # es solo de disponibilidad. Lo compensan los backups de 7 días, el snapshot final
  # y deletion_protection. RTO aceptado 4 h, RPO 5 min. En producción no aplica.
  # checkov:skip=CKV_AWS_157:Staging sin Multi-AZ, riesgo aceptado | Aprobó: P. Pineda (resp. infraestructura), issue #1 | Vence: 2027-05-31
  identifier        = "taskapi-db"
  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name                     = "taskapi"
  username                    = "taskapi_admin"
  manage_master_user_password = true

  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false

  storage_encrypted = true
  kms_key_id        = aws_kms_key.taskapi.arn

  # Respaldos diarios con 7 días de retención y snapshot final al borrar
  backup_retention_period   = 7
  backup_window             = "07:00-08:00"
  copy_tags_to_snapshot     = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "taskapi-db-final"
  deletion_protection       = true

  auto_minor_version_upgrade = true
  maintenance_window         = "sun:08:00-sun:09:00"

  # Las apps entran con un token de IAM en vez de una contraseña fija
  iam_database_authentication_enabled = true

  # Monitoreo y registros
  parameter_group_name            = aws_db_parameter_group.app.name
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = 60
  monitoring_role_arn             = aws_iam_role.rds_monitoreo.arn
  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.taskapi.arn
}

# Registra los cambios de esquema y las consultas lentas, y obliga TLS
resource "aws_db_parameter_group" "app" {
  name   = "taskapi-postgres16"
  family = "postgres16"

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }
}

# Rol que usa RDS para mandar las métricas del monitoreo mejorado a CloudWatch
resource "aws_iam_role" "rds_monitoreo" {
  name = "taskapi-rds-monitoreo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoreo" {
  role       = aws_iam_role.rds_monitoreo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
