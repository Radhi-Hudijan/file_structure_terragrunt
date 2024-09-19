output "endpoint" {
  value = aws_db_instance.my_terragrunt_mysql.endpoint

}

output "db_name" {
  value = aws_db_instance.my_terragrunt_mysql.db_name

}

output "arn" {
  value = aws_db_instance.my_terragrunt_mysql.arn
}
