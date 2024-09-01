#!/bin/bash
# Set any ECS agent configuration variables here
echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config
