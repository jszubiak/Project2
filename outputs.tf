output "server_public_ip" {
  value = aws_eip.out.private_ip
}
