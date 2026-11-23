# Grupos de seguridad del servidor web y de la base de datos.
# La API es interna: se usa desde la VPN, así que nada queda abierto a Internet.

resource "aws_security_group" "web" {
  name        = "taskapi-web"
  description = "Servidor web de la API de tareas"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "web_https_vpn" {
  security_group_id = aws_security_group.web.id
  description       = "HTTPS a la API desde la VPN"
  cidr_ipv4         = var.cidr_vpn
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh_vpn" {
  security_group_id = aws_security_group.web.id
  description       = "SSH para Ansible, solo desde la VPN"
  cidr_ipv4         = var.cidr_vpn
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_https_salida" {
  security_group_id = aws_security_group.web.id
  description       = "HTTPS de salida (paquetes y APIs externas)"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_a_db" {
  security_group_id            = aws_security_group.web.id
  description                  = "PostgreSQL hacia la base de datos"
  referenced_security_group_id = aws_security_group.db.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "db" {
  name        = "taskapi-db"
  description = "Base de datos PostgreSQL de la API de tareas"
  vpc_id      = var.vpc_id
}

# PostgreSQL solo acepta conexiones del servidor web
resource "aws_vpc_security_group_ingress_rule" "db_desde_web" {
  security_group_id            = aws_security_group.db.id
  description                  = "PostgreSQL solo desde el servidor web"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
