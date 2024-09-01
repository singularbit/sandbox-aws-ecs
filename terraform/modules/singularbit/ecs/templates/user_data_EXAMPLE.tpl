Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

%{ if attach_efs } --==BOUNDARY==
Content-Type: text/cloud-boothook; charset="us-ascii"

# Install amazon-efs-utils
cloud-init-per once yum_update yum -y update
cloud-init-per once install_amazon_efs_utils yum -y install amazon-efs-utils

# Create /efs folder
cloud-init-per once create_efs_folder mkdir /efs

# Mount EFS
cloud-init-per once mount_efs echo -e '${efs_if}:/ /efs efs defaults,_netdev 0 0' >> /etc/fstab
mount -a
%{ endif } --==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
# Set any ECS agent configuration options
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

--==BOUNDARY==--
