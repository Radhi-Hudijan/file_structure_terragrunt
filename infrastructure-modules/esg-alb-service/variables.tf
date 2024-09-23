variable "name" {
  description = "The name of the ALB"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum size of the ASG"
  type        = number
}

variable "instance_type" {
  description = "The instance type of the ASG"
  type        = string
}

variable "server_port" {
  description = "The port the server will listen on"
  type        = number
}

variable "alb_port" {
  description = "The port the ALB will listen on"
  type        = number

}
