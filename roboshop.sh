#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0af7c8cc8d4bcb618
#aws ec2 run-instances --image-id ami-03265a0778a880afb 
#--instance-type t2.micro 
#--security-group-ids sg-0af7c8cc8d4bcb618


ZONE_ID=Z0052568278EYAYP4D07R
DOMAIN_NAME=awsjoindevops.online

INSTANCES=("cart" "catalogue" "mongodb" "mysql" "redis" "rabbitmq" "shipping"
 "payment" "user" "web" "dispatch")

 for i in "${INSTANCES[@]}"
 do 

if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
then
INSTANCES_TYPE="t3.small"
else
INSTANCES_TYPE="t2.micro"
fi

IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCES_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

echo "$i : $IP_ADDRESS"


#CREATE ROUTE 53
aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
  {
    "Comment": "Testing creating a record set"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }'

done
