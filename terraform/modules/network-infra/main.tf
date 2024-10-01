data "aws_vpc" "main" {
    id = var.vpc_id
}

resource "aws_subnet" "private_subnet" {
    vpc_id                  = data.aws_vpc.main.id
    cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 1)
    map_public_ip_on_launch = true
    availability_zone       = "us-east-2a"
}

resource "aws_subnet" "public_subnet" {
    vpc_id                  = data.aws_vpc.main.id
    cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 2)
    map_public_ip_on_launch = true
    availability_zone       = "us-east-2b"
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = data.aws_vpc.main.id
    tags = {
        Name = "internet_gateway"
    }
}

resource "aws_route_table" "primary_route_table" {
    vpc_id = data.aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "private_subnet_route" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.primary_route_table.id
}

resource "aws_route_table_association" "public_subnet_route" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.primary_route_table.id
}

resource "aws_security_group" "blackhat_security_group" {
    name   = "blackhat-ecs-security-group"
    vpc_id = data.aws_vpc.main.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        self        = "false"
        cidr_blocks = ["0.0.0.0/0"]
        description = "any"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}