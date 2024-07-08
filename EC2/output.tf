output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = var.elastic_ip == "yes" ? aws_eip.eip[0].public_ip : aws_instance.instance.public_ip
}
