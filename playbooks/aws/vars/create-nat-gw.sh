#!/bin/bash
aws ec2 allocate-address --region 'us-east-1' --domain vpc  > /tmp/tmp-address

cat /tmp/tmp-address | grep AllocationId | awk {'print $2'} | sed 's/"//g' > /tmp/allocate-address

aws ec2 describe-subnets  --region 'us-east-1' --filter Name=tag:Name,Values=*us-east-1a*public* --query 'Subnets[*].[SubnetId]' --output text | awk {'print $1'} > /tmp/public-subnet

aws ec2 describe-subnets  --region 'us-east-1' --filter Name=tag:Name,Values=*private* --query 'Subnets[*].[SubnetId]' --output text | awk {'print $1'} > /tmp/private-subnet

aws ec2 create-nat-gateway  --region 'us-east-1' --subnet-id $(cat /tmp/public-subnet) --allocation-id $(cat /tmp/allocate-address) > /tmp/tmp-nat

cat /tmp/tmp-nat | grep NatGatewayId | awk {'print $2'} | sed 's/"//g' | sed 's/,//g' > /tmp/nat-gateway

sleep 30
