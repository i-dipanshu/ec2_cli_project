#!/bin/bash
sudo apt-get update

# variables - us-east-2
ami_id="ami-0430580de6244e02e"
instance_type="t2.micro"
key_pair_name="MyKeyPair"
grp_name="my-sg"

# Creating a key pair and save it current directory
aws ec2 create-key-pair --key-name $key_pair_name --query 'KeyMaterial' --output text > MyKeyPair.pem

# Creating a security group and store its id in grp_id variable
grp_id=$(aws ec2 create-security-group --group-name $grp_name --description "My security group" --query 'GroupId' --output text)

# # generate my ip
my_ip="$(curl https://checkip.amazonaws.com)/32"

# # assign ingress rules to sg
aws ec2 authorize-security-group-ingress --group-id $grp_id --protocol tcp --port 22 --cidr $my_ip
aws ec2 authorize-security-group-ingress --group-id $grp_id --protocol tcp --port 80 --cidr 0.0.0.0/0

# Creating the instance
instance_id=$(aws ec2 run-instances \
    --image-id $ami_id \
    --count 1 \
    --instance-type $instance_type \
    --key-name $key_pair_name \
    --security-group-ids $grp_id \
    --user-data file://./usrdata.sh \
    --output text --query 'Instances[0].InstanceId')

# Fetching the public ip
public_ip=$(aws ec2 describe-instances --instance-ids $instance_id \
    --query 'Reservations[-1].Instances[-1].PublicIpAddress' \
    --output text)

echo "grp_id: $grp_id, instance_id: $instance_id, public_ip: $public_ip, key_name: $key_pair_name" > id.txt

cat id.txt
