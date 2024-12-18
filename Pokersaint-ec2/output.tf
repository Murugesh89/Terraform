output "ec2-instance" {
  value = aws_instance.ubuntu22.id
}
output "public-ip" {
  value = aws_instance.ubuntu22.public_ip
}