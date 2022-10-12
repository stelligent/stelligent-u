output "vpc_id" {
  value       = aws_vpc.main.id
}

output "subnet_id" {
    value = aws_subnet.subnet1.id
}

output "subnet_id_2" {
    value = aws_subnet.subnet2.id
}
