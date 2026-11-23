# Caso que PASA la política CKV2_GAL_1.

resource "aws_security_group" "web" {
  name        = "prueba-web"
  description = "Grupo de prueba para la politica CKV2_GAL_1"
  vpc_id      = "vpc-0a1b2c3d4e5f60789"
}

resource "aws_security_group" "db" {
  name        = "prueba-db"
  description = "Grupo de prueba para la politica CKV2_GAL_1"
  vpc_id      = "vpc-0a1b2c3d4e5f60789"
}

# HTTPS a Internet: es lo único permitido
resource "aws_vpc_security_group_ingress_rule" "https_internet" {
  security_group_id = aws_security_group.web.id
  description       = "HTTPS publico"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# SSH solo desde la VPN
resource "aws_vpc_security_group_ingress_rule" "ssh_vpn" {
  security_group_id = aws_security_group.web.id
  description       = "SSH solo desde la VPN"
  cidr_ipv4         = "10.20.0.0/16"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# PostgreSQL solo desde el grupo del servidor web
resource "aws_vpc_security_group_ingress_rule" "postgres_desde_web" {
  security_group_id            = aws_security_group.db.id
  description                  = "PostgreSQL desde el servidor web"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
