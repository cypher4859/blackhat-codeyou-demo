data "aws_caller_identity" "current" {}

locals {
    acct_id = data.aws_caller_identity.current.account_id
}

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "blackhat-demo-managed-ecs"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
    name = "ec2_capacity_provider"

    auto_scaling_group_provider {
        auto_scaling_group_arn = var.asg_arn

        managed_scaling {
            maximum_scaling_step_size = 1000
            minimum_scaling_step_size = 1
            status                    = "ENABLED"
            target_capacity           = 3
        }
    }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
    cluster_name = aws_ecs_cluster.ecs_cluster.name

    capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

    default_capacity_provider_strategy {
        base              = 1
        weight            = 100
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    }
}

resource "aws_ecs_task_definition" "cowabunga_ecs_task_definition" {
    family             = "cowabunga-ecs-task" # TODO: Swap this
    network_mode       = "awsvpc"
    execution_role_arn = "arn:aws:iam::${local.acct_id}:role/ecsTaskExecutionRole"
    cpu                = 256
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    container_definitions = jsonencode([
    ])
}

resource "aws_ecs_task_definition" "cowabunga_db_ecs_task_definition" {
    family             = "cowabunga-db-ecs-task" # TODO: Swap this
    network_mode       = "awsvpc"
    execution_role_arn = "arn:aws:iam::${local.acct_id}:role/ecsTaskExecutionRole"
    cpu                = 512
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    container_definitions = jsonencode([
        {
            name      = "cowabunga"
            image     = "docker.io/cypher4859/cowabunga-pizza:latest" # TODO: Swap this for the actual 
            cpu       = 256
            memory    = 1024
            essential = true
            portMappings = [
                {
                    containerPort = 8080
                    hostPort      = 8080
                    protocol      = "tcp"
                },
                {
                    containerPort = 22
                    hostPort      = 4444
                    protocol      = "tcp"
                }
            ],
            dependsOn = [
                {
                    containerName   = "cowabunga-db",
                    condition       = "START"
                }
            ]
        },
        {
            name      = "cowabunga-db"
            image     = "docker.io/cypher4859/cowabunga-db:latest" # TODO: Swap this for the actual 
            cpu       = 256
            memory    = 1024
            essential = true
            environment = [
                {"name": "MYSQL_DATABASE", "value": "cowabunga"},
                {"name": "MYSQL_ROOT_PASSWORD", "value": "mysqluser123"},
                {"name": "MYSQL_USER", "value": "raphael"},
                {"name": "MYSQL_PASSWORD", "value": "raphael123"}
            ]
            portMappings = [
                {
                    containerPort = 22
                    hostPort      = 22
                    protocol      = "tcp"
                },
                {
                    containerPort = 3306
                    hostPort      = 3306
                    protocol      = "tcp"
                }
            ],
        },
        {
            name      = "cowabunga-db-initialize"
            image     = "docker.io/cypher4859/cowabunga-db:latest" # TODO: Swap this for the actual 
            cpu       = 256
            memory    = 1024
            essential = false
            entryPoint = [
                "bash", "-c", "mysql -u root --password=mysqluser123 -h cowabunga-db < initialize_database.sql",
            ],
            dependsOn = [
                {
                    containerName   = "cowabunga-db",
                    condition       = "START"
                }
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "jupyter_mail_ftpd_ecs_task_definition" {
    family             = "jupyter-ecs-task" # TODO: Swap this
    network_mode       = "awsvpc"
    execution_role_arn = "arn:aws:iam::${local.acct_id}:role/ecsTaskExecutionRole"
    cpu                = 256
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    container_definitions = jsonencode([
        {
            name      = "jupyter"
            image     = "docker.io/cypher4859/vuln_jupyter:latest" # TODO: Swap this for the actual 
            cpu       = 256
            memory    = 1024
            essential = true
            portMappings = [
                {
                    containerPort = 8888
                    hostPort      = 8888
                    protocol      = "tcp"
                }
            ]
        },
    ])
}
resource "aws_ecs_task_definition" "smtpd_ecs_task_definition" {
    family             = "smtpd-ecs-task" # TODO: Swap this
    network_mode       = "awsvpc"
    execution_role_arn = "arn:aws:iam::${local.acct_id}:role/ecsTaskExecutionRole"
    cpu                = 256
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    container_definitions = jsonencode([
        {
            name      = "smtpd"
            image     = "vulhub/opensmtpd:6.6.1p1" # TODO: Swap this for the actual 
            cpu       = 256
            memory    = 1024
            essential = true
            portMappings = [
                {
                    containerPort = 25
                    hostPort      = 25
                    protocol      = "tcp"
                }
            ]
        },
    ])
}

resource "aws_ecs_task_definition" "ftpd_ecs_task_definition" {
    family             = "ftpd-ecs-task" # TODO: Swap this
    network_mode       = "awsvpc"
    execution_role_arn = "arn:aws:iam::${local.acct_id}:role/ecsTaskExecutionRole"
    cpu                = 256
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    container_definitions = jsonencode([
        {
            name      = "ftpd_server"
            image     = "docker.io/cypher4859/vuln_ftpd_server:latest" # TODO: Swap this for the actual 
            cpu       = 256
            memory    = 1024
            essential = true
            portMappings = [
                {
                    containerPort = 21
                    hostPort      = 21
                    protocol      = "tcp"
                },
                {
                    containerPort = 61000
                    hostPort      = 61000
                    protocol      = "tcp"
                },
                # {
                #     containerPortRange = 30000-30009
                #     hostPortRange = 30000-30009
                #     protocol      = "tcp"
                # }
            ],
            environment = [
                {"name": "FTP_USER_NAME", "value": "admin"},
                {"name": "FTP_USER_PASS", "value": "adkljeiasdkl8973"},
                {"name": "FTP_USER_HOME", "value": "/home/admin"}
            ]
        }
    ])
}

resource "aws_ecs_task_definition" "secret_postgresql_ecs_task_definition" {
    family             = "secret-postgresql-ecs-task" # TODO: Swap this
    network_mode       = "awsvpc"
    execution_role_arn = "arn:aws:iam::${local.acct_id}:role/ecsTaskExecutionRole"
    cpu                = 256
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
    }
    container_definitions = jsonencode([
        {
            name        = "super-secret-database"
            image       = "docker.io/bitnami/postgresql:latest"
            cpu         = 256
            memory      = 1024
            essential   = true
            portMappings = [
                {
                    containerPort   = 5432
                    hostPost        = 5432
                    protocol        = "tcp"
                }
            ],
            environment = [
                {"name": "POSTGRES_USER", "value": "postgres"},
                {"name": "POSTGRES_PASSWORD", "value": "postgres123"}
            ]
        }
    ])
}

resource "aws_ecs_service" "cowabunga_ecs_service" {
    name            = "blackhat-cowabunga-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.cowabunga_ecs_task_definition.arn
    desired_count   = 1
    # depends_on = [ aws_ecs_service.public_subnet_ecs_service["cowabunga-db"] ]

    network_configuration {
        subnets         = var.subnets
        security_groups = var.security_groups
    }

    force_new_deployment = true
    placement_constraints {
        type = "distinctInstance"
    }

    triggers = {
        redeployment = plantimestamp()
    }

    capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
        weight            = 100
    }

    load_balancer {
        target_group_arn = var.alb_target_group_arn
        container_name   = "cowabunga"
        container_port   = 8080
    }
}

resource "aws_ecs_service" "public_subnet_ecs_service" {
    for_each = tomap({
        "cowabunga-db"  = aws_ecs_task_definition.cowabunga_db_ecs_task_definition.arn
        "jupyter"       = aws_ecs_task_definition.jupyter_mail_ftpd_ecs_task_definition.arn
        "smtpd"         = aws_ecs_task_definition.smtpd_ecs_task_definition.arn
        "ftpd"          = aws_ecs_task_definition.ftpd_ecs_task_definition.arn
    })
    name            = "blackhat-${each.key}-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = each.value
    desired_count   = 1

    network_configuration {
        subnets         = var.subnets
        security_groups = var.security_groups
    }

    force_new_deployment = true
    placement_constraints {
        type = "distinctInstance"
    }

    triggers = {
        redeployment = plantimestamp()
    }

    capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
        weight            = 100
    }
}

resource "aws_ecs_service" "private-subnet-service" {
    for_each = tomap({
        "postgresl"   = aws_ecs_task_definition.secret_postgresql_ecs_task_definition.arn
    })
    name            = "blackhat-${each.key}-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = each.value
    desired_count   = 1

    network_configuration {
        subnets         = var.subnets
        security_groups = var.security_groups
    }

    force_new_deployment = true
    placement_constraints {
        type = "distinctInstance"
    }

    triggers = {
        redeployment = plantimestamp()
    }

    capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
        weight            = 100
    }
}