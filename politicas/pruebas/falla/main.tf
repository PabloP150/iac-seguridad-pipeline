# Caso que FALLA la política CKV2_GAL_1: puertos de bases de datos abiertos a Internet.

resource "aws_security_group" "cache" {
  name        = "prueba-cache"
  description = "Grupo de prueba para la politica CKV2_GAL_1"
  vpc_id      = "vpc-0a1b2c3d4e5f60789"
}

# MySQL abierto a todo IPv4
resource "aws_vpc_security_group_ingress_rule" "mysql_internet" {
  security_group_id = aws_security_group.cache.id
  description       = "MySQL desde Internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}

# Redis abierto a todo IPv6
resource "aws_vpc_security_group_ingress_rule" "redis_internet_v6" {
  security_group_id = aws_security_group.cache.id
  description       = "Redis desde Internet por IPv6"
  cidr_ipv6         = "::/0"
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
}

# 443 pero con todos los protocolos: también falla
resource "aws_vpc_security_group_ingress_rule" "todo_internet" {
  security_group_id = aws_security_group.cache.id
  description       = "Todos los protocolos desde Internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
