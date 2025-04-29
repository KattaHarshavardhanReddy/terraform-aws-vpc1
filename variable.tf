variable "project_name" {

}

variable "env" {

}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames"{
    default = "true"
}


variable "common_tags" {
    type = map
    default = { }
}


variable "abc" {
    default= {
        purpose = "assignment"
     }
}

variable "igw_tags" {
    default= {}
}

variable "public_cidr_subnet" {
    type = list 
    validation {
      condition = length(var.public_cidr_subnet) == 2
      error_message = "please provide 2 public subnet id"
    }
}

variable "private_cidr_subnet" {
    type = list 
    validation {
      condition = length(var.private_cidr_subnet) == 2
      error_message = "please provide 2 private subnet id"
    }
}

variable "public_subnet_tags"{
    default= {}
}

variable "private_subnet_tags"{
    default= {}
}

variable "nat_tags"{
    default= {}
}

variable "public_route_tags"{
    default= {}
}

variable "private_route_tags"{
    default= {}
}


