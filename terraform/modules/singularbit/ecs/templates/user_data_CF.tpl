#!/bin/bash

echo ECS_CLUSTER=${ECSCluster} >> /etc/ecs/ecs.config

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
yum install -y aws-cli

# aws s3 cp s3://<bucket-name>/sysdig-bootstrap.sh /tmp/
# chmod +x /tmp/sysdig-bootstrap.sh
# /tmp/sysdig-bootstrap.sh ${StackDescriptor}

yum install -y aws-cfn-bootstrap
/opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource ECSAutoScalingGroup --region ${AWS::Region}