variable "security_groups" {
    type = list(string)
    description = "List of Security Group IDs for ECS"
}

variable "subnets" {
    type = list(string)
    description = "List of subnet IDs for the VPC"
}

variable "launch_template_key_name" {
    type = string
    description = "Key Pair name to use in the Launch Template"
}


