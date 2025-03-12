output "server_ips" {
  value = aws_instance.servers[*].public_ip
}
