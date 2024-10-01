variable "public_subnet_id" {
    type = string
    description = "ID of the public subnet"
}

# variable "kali_private_ip" {
#     type = string
#     description = "Private IP to assign. Should be a single one."
# }

variable "key_name" {
    type = string
    description = "Key pair to use for SSH access"
}

variable "vpc_id" {
    type = string
    description = "ID of the VPC"
}