terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.13"
}


# Create a new MySQL database

resource "aws_db_instance" "my_terragrunt_mysql" {
  allocated_storage   = var.allocated_storage
  engine              = "mysql"
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_name             = var.name
  username            = var.username
  password            = var.password
  skip_final_snapshot = var.skip_final_snapshot
  storage_type        = var.storage_type
}
