variable "security_groups" {
    type = list(string)
    description = "A list of security group IDs"
}

variable "subnets" {
    type = list(string)
    description = "List of subnet IDs"
}

variable "vpc_id" {
    type = string
    description = "ID of the main VPC"
}