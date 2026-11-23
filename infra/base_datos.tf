# Base de datos PostgreSQL de la API.

resource "aws_db_instance" "app" {
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
}
