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

dnf module disable nodejs -y  &>> $LOGFILE
VALIDATE $? "Disable the NodsJS"

dnf module enable nodejs:18 -y   &>> $LOGFILE
VALIDATE $? "Enable the NodsJS of 18 version"


dnf install nodejs -y   &>> $LOGFILE
VALIDATE $? "Installing NodeJS"

useradd roboshop  &>> $LOGFILE
VALIDATE $? "Installing NodeJS"

useradd roboshop &>> $LOGFILE
VALIDATE $? "User Add to Roboshop"

mkdir /app &>> $LOGFILE
VALIDATE $? "Create APP Directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Download application code"

cd /app 
VALIDATE $? "NAVIGATE TO APP directory"

npm install &>> $LOGFILE
VALIDATE $? "Installig NPM"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "Copying the catalogue to services"


systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reload"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enable catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "start catalogue"


cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copying mongo repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "install mongo client"

mongo --host mongodb.awsjoindevops.online </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "LOADING catalogue data in mongo DB"



