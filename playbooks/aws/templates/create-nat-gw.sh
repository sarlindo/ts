#!/bin/bash
aws ec2 allocate-address --region '{{ vpc_region }}' --domain vpc  > /tmp/tmp-address

cat /tmp/tmp-address | grep AllocationId | awk {'print $2'} | sed 's/"//g' > /tmp/allocate-address

aws ec2 describe-subnets  --region '{{ vpc_region }}' --filter Name=tag:Name,Values=*{{ public_az_1 }}*public* --query 'Subnets[*].[SubnetId]' --output text | awk {'print $1'} > /tmp/public-subnet

aws ec2 describe-subnets  --region '{{ vpc_region }}' --filter Name=tag:Name,Values=*private* --query 'Subnets[*].[SubnetId]' --output text | awk {'print $1'} > /tmp/private-subnet

aws ec2 create-nat-gateway  --region '{{ vpc_region }}' --subnet-id $(cat /tmp/public-subnet) --allocation-id $(cat /tmp/allocate-address) > /tmp/tmp-nat

cat /tmp/tmp-nat | grep NatGatewayId | awk {'print $2'} | sed 's/"//g' | sed 's/,//g' > /tmp/nat-gateway

sleep 30
