Ansible TICKSMITH
----------------------

The purpose of Ansible project is to create a fully operational AWS VPC infrastructure(subnets,routing tables,igw etc), it will also create everything that need to be for creating EC2 and RDS instances (security key, security group, subnet group).

It will also create the Elastic Load Balancer and add the EC2 instance(s) automatically that were created using this playbook as well as creating the Route53 entry for this site and add the ELB alias to it. 

Beside that, this playbook will also run the essential role(updating and patching the OS, configuring NTP,creating users etc) and deploy the wordpress on them, that will be fault tolerant and highly available.

**NOTE:** The part of the play, 'webserver.yml', is not idempotent. Every time it is run, it will create a new EC2 instances.

### Playbook Tasks:

- Create 1 x VPC with 3 x VPC subnets(2 x public and 1 x private) in differrent AZ zones one AWS region
- Create the AWS key pair with the ansible host's login user's public key
- Create 1 x security group for each(Webservers,RDS and ELB)
- Provision 2 x EC2 instances(Ubuntu 14.04 LTS) in 2 different AZ
- Provision 1 x RDS instance in private subnet
- Launch and configure public facing VPC ELB (cross_az_load_balancing) and attach VPC subnets
- Register EC2 instances on ELB
- Install essential and webservers role on both instances
- Take the ELB dnsname and register/create dns entry in Route53

All informations about VPC, Webserver, RDS, ELB, Route53 are defined in their respective files (vpc.yml,webserver.yml,rds.yml,elb.yml,route53 etc) for both variables and tasks.

### Requirements:

- Ansible
- boto
- AWS admin access

### AWS credentials:

Ansible uses python-boto library to call AWS API, and boto needs AWS credentials in order to perform all the functions. There are many ways to configure your AWS credentials. The easiest way is to crate a .boto file under your user home directory:
```shell
vim ~/.boto
```
Then add the following:
```shell
[Credentials]
aws_access_key_id = <your_access_key_here>
aws_secret_access_key = <your_secret_key_here>
```

### To use this Role:

Edit the vars files inside the `groups_vars/all` directory as per your requirement:

