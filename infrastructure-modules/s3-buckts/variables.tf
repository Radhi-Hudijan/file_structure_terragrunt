
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

}

variable "block_public_access" {
  type    = bool
  default = true
}
