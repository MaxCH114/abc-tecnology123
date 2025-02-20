
variable "project_name" {
  type = string
}

variable "netw_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "db_subnets_cidr" {
  type = list(string)

}
variable "availability_zones" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "my_ip" {
  type = list(string)
}