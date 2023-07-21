

output "db_port" {
  value = aws_db_instance.this.port
}


output "db_host" {
  value = aws_db_instance.this.address
}

output "db_pass" {
  value     = var.pass
  sensitive = true
}
output "db_name" {
  value = aws_db_instance.this.db_name
}

output "db_username" {
  value = aws_db_instance.this.username

}
