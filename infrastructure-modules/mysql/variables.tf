variable "engine_version" {
  description = "The version of the database engine to use"
  type        = string
  default     = "8.0.36"
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
}

variable "name" {
  description = "The name of the database"
  type        = string
}

variable "username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot"
  type        = bool
  default     = false

}

variable "storage_type" {
  description = "The storage type to use"

}

variable "allocated_storage" {
  description = "The amount of storage to allocate"

}
