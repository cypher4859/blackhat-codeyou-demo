output "security_groups" {
    value = [aws_security_group.blackhat_security_group.id]
    description = "Security groups used in the main VPC"
}

output "vpc_id" {
    value = data.aws_vpc.main.id
    description = "ID of the main VPC"
}

output "subnets" {
    value = [aws_subnet.private_subnet.id, aws_subnet.public_subnet.id]
    description = "Subnets inside of the main VPC"
}

output "public_subnet" {
    value = aws_subnet.public_subnet.id
    description = "Public Subnet inside of the main VPC"
}

output "private_subnet" {
    value = aws_subnet.private_subnet.id
    description = "Private Subnet inside of the main VPC"
}