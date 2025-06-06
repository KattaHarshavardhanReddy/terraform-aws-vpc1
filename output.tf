# output "azs_info" {
#     value = "data.aws_availability_zones.available" 
# }

output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
    value = "aws_subnet_public[*].id"
}

output "private_subnet_ids" {
    value = "aws_subnet_private[*].id"
}