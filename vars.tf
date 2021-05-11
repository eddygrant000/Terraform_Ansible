variable "EC2_USER" {
  default = "ubuntu"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

# variable "username" {
#   default = "eddygrant"
# }

# variable "password" {
#   default = "Redhat!123"
# }

# variable "app_addr" {
#   default     = aws_instance.appserver.private_ip
# }