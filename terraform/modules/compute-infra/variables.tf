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

variable "launch_template_key_name" {
    type = string
    description = "Key Pair name to use in the Launch Template"
}

variable "kali_subnet" {
    type = string
    description = "Subnet for Kali"
}