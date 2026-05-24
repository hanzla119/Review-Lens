output "vpc_id" {
 value = aws_vpc.main.id
}
output "public_subnet_id" {
 value = aws_subnet.public.id
}
output "private_subnet_id" {
 value = aws_subnet.private.id
}
output "frontend_sg_id" {
 value = aws_security_group.frontend.id
}
output "mongodb_private_ip" {
  description = "The secure internal IP address of the MongoDB database server"
  value       = aws_instance.mongodb.private_ip
}