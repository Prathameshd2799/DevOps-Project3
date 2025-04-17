output "id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.host[*].id
}
 
output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.host[*].private_ip
}
 
output "ec2_ami_id" {
  value = data.aws_ami.ec2_ami.id
}
 
output "available_ip_address_counts" {
  value = {
    for subnet_id, details in data.aws_subnet.subnet :
    subnet_id => details.available_ip_address_count
  }
}
 
output "ip_counts" {
  value = local.ip_counts
}
 
output "filtered_subnets" {
  value = local.filtered_subnets
}
 
output "first_filtered_subnet" {
  value = element(keys(local.filtered_subnets), 0)
}
 