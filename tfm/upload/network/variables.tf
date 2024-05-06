variable "public_subnets" {
    type = list(string)
    default = ["10.0.2.0/24", "10.0.3.0/24"]
  
}

variable "region" {}

variable "env" {
  
}