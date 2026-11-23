# Grupos de seguridad del servidor web y de la base de datos.
# Versión inicial con configuraciones inseguras a propósito para el laboratorio.

resource "aws_security_group" "web" {
  name   = "taskapi-web"
  vpc_id = var.vpc_id
}

# "Para que funcione todo": abre todos los puertos TCP a Internet
resource "aws_vpc_security_group_ingress_rule" "web_todo" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 65535
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_salida" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "db" {
  name   = "taskapi-db"
  vpc_id = var.vpc_id
}

# PostgreSQL abierto a cualquiera
resource "aws_vpc_security_group_ingress_rule" "db_postgres" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}
