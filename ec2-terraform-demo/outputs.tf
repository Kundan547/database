output "react_app_public_ip" {
  description = "Public IP address of the React app server"
  value       = aws_instance.react_app.public_ip
}

output "react_app_public_dns" {
  description = "Public DNS of the React app server"
  value       = aws_instance.react_app.public_dns
}
output "key_name" {
  description = "The name of the key pair to use for SSH access"
  value       = var.key_name
  
}
output "security_groups" {
  description = "The security groups associated with the instance"
  value       = aws_instance.react_app.security_groups
  
}
output "ami_id" {
  description = "The Amazon Machine Image (AMI) ID for the instance"
  value       = var.ami_id
  
}
output "instance_type" {
  description = "The instance type for the React app server"
  value       = var.instance_type
  
}
output "aws_region" {
  description = "The AWS region to deploy resources in"
  value       = var.aws_region
  
}