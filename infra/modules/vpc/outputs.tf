output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}
