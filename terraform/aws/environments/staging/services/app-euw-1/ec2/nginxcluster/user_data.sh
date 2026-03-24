#!/bin/bash

# Install the AWS CLI
sudo yum install -y aws-cli

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Enable and start the AWS Systems Manager Agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Install EC2 Instance Connect
sudo yum install ec2-instance-connect -y
