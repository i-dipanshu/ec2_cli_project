#!/bin/bash

# vars
sg_id="$(awk '{ print $2 }' FS='[:,]' id.txt)"
instance_id="$(awk '{ print $4 }' FS='[:,]' id.txt)"
kp_name="$(awk '{ print $8 }' FS='[:,]' id.txt)"


aws ec2 terminate-instances --instance-ids $instance_id

state=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].State.Name' --output text)

while [[ $state != "terminated" ]]; do
    state=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].State.Name' --output text)
    echo "Instance is in $state state and still is to be deleted ...."
    sleep 5
done

echo "Instance terminated"

aws ec2 delete-key-pair --key-name $kp_name

aws ec2 delete-security-group --group-id $sg_id

echo "----------------------------------------------------------------"
echo " Resources deleted "