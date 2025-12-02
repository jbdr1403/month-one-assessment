# 1. VPC ID
output "vpc_id" {
  description = "ID of the TechCorp VPC"
  value       = aws_vpc.techcorp_vpc.id
}

# 2. Bastion Public IP
output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_eip.bastion_eip.public_ip
}

# 3. Load Balancer DNS
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.techcorp_alb.dns_name
}

output "web1_private_ip" {
  value = aws_instance.web_server_1.private_ip
}

output "web2_private_ip" {
  value = aws_instance.web_server_2.private_ip
}
