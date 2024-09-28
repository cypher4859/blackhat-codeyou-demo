module "autoscaling" {
    source = "./autoscaling-and-template"
}

module "app-load-balancer" {
    source = "./alb"
}

module "ecs-infra" {
    source = "./ecs-infra"
}