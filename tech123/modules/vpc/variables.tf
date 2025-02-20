

variable "project_name" {
  type = string
}

variable "netw_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "db_subnets_cidr" {
  description = "List of CIDR blocks for DB subnets"
  type        = list(string)
  default     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones in the region"
  type        = list(string)
 # default     = ["us-west-2a", "us-west-2b", "us-west-2c"]  # Adjust based on your region
}


