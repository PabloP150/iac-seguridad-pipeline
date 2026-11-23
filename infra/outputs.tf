output "ip_privada_web" {
  description = "IP privada del servidor web (la usa el inventario de Ansible)"
  value       = aws_instance.web.private_ip
}

output "endpoint_db" {
  description = "Endpoint de la base de datos"
  value       = aws_db_instance.app.address
}
