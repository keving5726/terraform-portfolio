output "db_config" {
  description = "Connection details for the database configuration"
  value = {
    hostname = aws_db_instance.database.address
    port     = aws_db_instance.database.port
    database = aws_db_instance.database.db_name
    user     = aws_db_instance.database.username
    password = aws_db_instance.database.password
  }
}
