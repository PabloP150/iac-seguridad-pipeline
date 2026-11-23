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

  storage_encrypted          = false
  backup_retention_period    = 0
  skip_final_snapshot        = true
  deletion_protection        = false
  auto_minor_version_upgrade = false
}
