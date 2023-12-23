#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0af7c8cc8d4bcb618
#aws ec2 run-instances --image-id ami-03265a0778a880afb 
#--instance-type t2.micro 
#--security-group-ids sg-0af7c8cc8d4bcb618


INSTANCES=("cart" "catalogue" "mongodb" "mysql" "redis" "rabbitmq" "shipping"
 "payment" "user" "web" "dispatch")

 for i in "${INSTANCES[@]}"
 do 

echo "instance name : $i"
if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
then
INSTANCES_TYPE="t3.small"
else
INSTANCES_TYPE="t2.micro"
fi

aws ec2 run-instances --image-id $AMI --instance-type $INSTANCES_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done
