locals {
   resource_name = "${var.project_name}-${var.env}"
   azs = slice(data.aws_availability_zones.available.names,0,2)
   }