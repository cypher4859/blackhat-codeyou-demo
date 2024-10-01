module "kali_instance" {
  source = "./kali_instance"
  key_name = var.launch_template_key_name
  public_subnet_id = var.kali_subnet
  vpc_id = var.vpc_id
}

module "autoscaling" {
    source = "./autoscaling-and-template"
    subnets = var.subnets
    security_groups = var.security_groups
    launch_template_key_name = var.launch_template_key_name
}

module "app_load_balancer" {
    source = "./alb"
    security_groups = var.security_groups
    subnets = var.subnets
    vpc_id = var.vpc_id
}

module "ecs-infra" {
    source = "./ecs-infra"
    security_groups = var.security_groups
    subnets = var.subnets
    alb_target_group_arn = module.app_load_balancer.alb_target_group_arn
    asg_arn = module.autoscaling.asg_arn
    depends_on = [ module.autoscaling, module.app_load_balancer ]
}
