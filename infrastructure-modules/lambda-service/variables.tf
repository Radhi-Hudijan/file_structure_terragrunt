
variable "name" {
  description = "The name of the lambda function"
  type        = string

}

variable "source_dir" {
  description = "The directory of the lambda function source code"
  type        = string
}

variable "runtime" {
  description = "The runtime of the lambda function"
  type        = string
}

variable "handler" {
  description = "The handler of the lambda function"
  type        = string
}

variable "route_key" {
  description = "The route key of the lambda function"
  type        = string

}

variable "timeout" {
  description = "The timeout of the lambda function"
  type        = number
  default     = 3
}
variable "memory_size" {
  description = "The memory size of the lambda function"
  type        = number
  default     = 128
}
