output "server_public_ip" {
  value = aws_eip.out.public_ip
}

output "vpc" {
  value = aws_eip.out.vpc
}
