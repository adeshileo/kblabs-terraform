variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per AZ in var.azs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per AZ in var.azs"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}
