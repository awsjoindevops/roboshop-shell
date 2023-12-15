#!/bin/bash

ID=$(id -u)


R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

exec &>$LOGFILE

echo "Script started executing at  $TIMESTAMP"  &>>$LOGFILE



#VALIDATE METHOD
VALIDATE(){

 if [ $1 -ne 0 ]
        then
        echo  -e " $R ERROR :  $2 is -------FAILED $N"
        exit 1

        else
        echo  -e "$G $2 is ------- SUCCESS $N"
        fi
}

if [ $ID -ne 0 ] 
then
    echo "Error please run this script with root access"
    exit 1  # you can give other than 0
else
    echo "you are root user"
fi


dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  
VALIDATE $? "INSTALL remisrepo enterprise"

dnf module enable redis:remi-6.2 -y 
VALIDATE $? "enable redis"


dnf install redis -y 
VALIDATE $? "Install redis"


#IMPORTANT STEAM LINE EDITOR FOR THE REPLACEMENT
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf 
VALIDATE $? "Replace the remote connection ip of 127 redis to 0.0..."



systemctl enable redis
VALIDATE $? "enable redis"


systemctl start redis 
VALIDATE $? "start redis"



