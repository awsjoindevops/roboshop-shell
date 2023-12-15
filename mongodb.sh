#!/bin/bash

ID=$(id -u)


R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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

#Step-1
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE 
VALIDATE $? "Mongo repo is copied successfully"

dnf install mongodb-org -y  &>> $LOGFILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enable MongoDB"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Start mongoDB"


#IMPORTANT STEAM LINE EDITOR FOR THE REPLACEMENT
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Replace the ip of 127 mongoDB to 0.0..."

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restart the MongoDB"
