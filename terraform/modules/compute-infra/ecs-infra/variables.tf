variable "asg_arn" {
    type = string
    description = "The ARN of the AutoScaling Group for ECS"
}

variable "subnets" {
    type = list(string)
    description = "Subnets used in the VPC"
}

variable "security_groups" {
    type = list(string)
    description = "List of security groups to use for ECS"
}

variable "alb_target_group_arn" {
    type = string
    description = "The ARN fo the ALB's Target Group"
}