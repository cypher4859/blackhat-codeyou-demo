#!/bin/bash
echo ECS_CLUSTER=blackhat-demo-managed-ecs >> /etc/ecs/ecs.config
echo ECS_IMAGE_PULL_BEHAVIOR=always >> /etc/ecs/ecs.conf