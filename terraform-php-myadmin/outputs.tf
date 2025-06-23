output "instance_public_ip" {
  value = aws_instance.phpmyadmin.public_ip
}

output "phpmyadmin_url" {
  value = "http://${aws_instance.phpmyadmin.public_ip}/phpmyadmin"
}