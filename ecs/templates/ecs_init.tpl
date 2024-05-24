#!/bin/bash
set -eux

yum update -y
yum install aws-cli -y
sudo yum install amazon-cloudwatch-agent -y
sudo amazon-linux-extras install epel -y
sudo yum install stress -y


echo "### AWS Region"
export AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
mkdir -p /root/.aws
echo -e "[default]\nregion=$AWS_REGION" | tee /root/.aws/config


echo "### HARDENING DOCKER"
sed -i "s/1024:4096/65535:65535/g" "/etc/sysconfig/docker"

echo "### HARDENING EC2 INSTACE"
echo "ulimit -u unlimited" >> /etc/rc.local
echo "ulimit -n 1048576" >> /etc/rc.local
echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf
/sbin/sysctl -p /etc/sysctl.conf

mkdir -p /usr/share/collectd/
touch /usr/share/collectd/types.db

echo 'ECS_CLUSTER=${cluster_name}'> /etc/ecs/ecs.config
echo "ECS_ENABLE_SPOT_INSTANCE_DRAINING=true" >> /etc/ecs/ecs.config

start ecs

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:config_cloudwatch_agent -s

