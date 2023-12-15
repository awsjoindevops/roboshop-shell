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

id roboshop
if [ $? -ne 0 ]  
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "add roboshop"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Create APP Directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip 
VALIDATE $? "Download application code"

cd /app &>> $LOGFILE
VALIDATE $? "NAVIGATE TO APP directory"

unzip -o /tmp/cart.zip &>>$LOGFILE
VALIDATE $? "unzip cart"

cd /app &>> $LOGFILE
VALIDATE $? "NAVIGATE TO APP dirGectory 2"

npm install &>> $LOGFILE
VALIDATE $? "Installig NPM"



cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "Copying the cart to services"


systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reload"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "Enable cart"

systemctl start cart &>> $LOGFILE
VALIDATE $? "start cart"




