resource "aws_launch_template" "ecs_lt" {
    name_prefix   = "ecs-blackhat-template"
    image_id      = "ami-0fc9e89bb58985752" # Amazon ECS-Optimized Amazon Linux 2 (AL2) x86_64 AMI AMI, pulled from AWS -> EC2 -> AMI Catalog
    instance_type = "t3.medium"

    key_name               = var.launch_template_key_name
    vpc_security_group_ids = var.security_groups
    iam_instance_profile {
        name = "ecsInstanceRole"
    }

    block_device_mappings {
        device_name = "/dev/xvda"
        ebs {
            volume_size = 30
            volume_type = "gp2"
        }
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "ecs-instance"
        }
    }

    user_data = filebase64("${path.module}/assets/ecs.sh")
}

resource "aws_autoscaling_group" "ecs_asg" {
    vpc_zone_identifier = var.subnets
    desired_capacity    = 2
    max_size            = 3
    min_size            = 1

    launch_template {
        id      = aws_launch_template.ecs_lt.id
        version = "$Latest"
    }

    tag {
        key                 = "AmazonECSManaged"
        value               = true
        propagate_at_launch = true
    }
}